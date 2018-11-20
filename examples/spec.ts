class Spec {
class Context {

}
record(Result, kind : Symbol, description : String, file : String, line : Int32, elapsed : Time::Span | ::Nil, exception : Exception | ::Nil)
class RootContext extends Context {
constructor() {
this.results = {success: [] of Result, fail: [] of Result, error: [] of Result, pending: [] of Result}
}
parent() {
nil
}
succeeded() {
@results[:fail].empty? && @results[:error].empty?
}
report(kind, full_description, file, line, elapsed, ex) {
let result: Crystal::Call = new Result(kind, full_description, file, line, elapsed, ex)
@@contexts_stack.last.report(result)
}
report(result) {
for (__arg0 of Spec.formatters()) {
__arg0.report(result)
}
@results[result.kind] << result
}
print_results(elapsed_time, aborted) {
@@instance.print_results(elapsed_time, aborted)
}
succeeded() {
@@instance.succeeded()
}
finish(elapsed_time, aborted) {
@@instance.finish(elapsed_time, aborted)
}
finish(elapsed_time, aborted) {
for (__arg1 of Spec.formatters()) {
__arg1.finish()
}
for (__arg2 of Spec.formatters()) {
__arg2.print_results(elapsed_time, aborted)
}
}
print_results(elapsed_time, aborted) {
let pendings: Crystal::Call = @results [] :pending
unless pendings.empty?
  puts
  puts("Pending:")
  pendings.each do |pending|
    puts(Spec.color("  #{pending.description}", :pending))
  end
end
let failures: Crystal::Call = @results [] :fail
let errors: Crystal::Call = @results [] :error
let failures_and_errors: Crystal::Call = failures + errors
unless failures_and_errors.empty?
  puts
  puts("Failures:")
  failures_and_errors.each_with_index do |fail, i|
    if ex = fail.exception
      puts
      puts("#{(i + 1).to_s.rjust(3, ' ')}) #{fail.description}")
      if ex.is_a?(AssertionFailed)
        source_line = Spec.read_line(ex.file, ex.line)
        if source_line
          puts(Spec.color("     Failure/Error: #{source_line.strip}", :error))
        end
      end
      puts
      message = ex.is_a?(AssertionFailed) ? ex.to_s : ex.inspect_with_backtrace
      (message.split('\n')).each do |line|
        print("       ")
        puts(Spec.color(line, :error))
      end
      if ex.is_a?(AssertionFailed)
        puts
        puts(Spec.color("     # #{Spec.relative_file(ex.file)}:#{ex.line}", :comment))
      end
    end
  end
end
if (Spec.slowest()) {
puts
results = @results[:success] + @results[:fail]
top_n = results.sort_by do |res|
  -res.elapsed.not_nil!.to_f
end[0..Spec.slowest.not_nil!]
top_n_time = top_n.sum do |__arg3|
  __arg3.elapsed.not_nil!.total_seconds
end
percent = (top_n_time * 100) / elapsed_time.total_seconds
puts("Top #{Spec.slowest} slowest examples (#{top_n_time} seconds, #{percent.round(2)}% of total time):")
top_n.each do |res|
  puts("  #{res.description}")
  res_elapsed = res.elapsed.not_nil!.total_seconds.to_s
  if Spec.use_colors?
    res_elapsed = res_elapsed.colorize.bold
  end
  puts("    #{res_elapsed} seconds #{Spec.relative_file(res.file)}:#{res.line}")
end

}
puts()
let success: Crystal::Call = @results [] :success
let total: Crystal::Call = (pendings.size + failures.size) + errors.size + success.size
let final_status: Crystal::Case = case
when aborted
  :error
when (failures.size + errors.size) > 0
  :fail
when pendings.size > 0
  :pending
else
  :success
end
if (aborted) {
puts("Aborted!".colorize.red)
}
puts("Finished in #{Spec.to_human(elapsed_time)}")
puts(Spec.color("#{total} examples, #{failures.size} failures, #{errors.size} errors, #{pendings.size} pending", final_status))
unless failures_and_errors.empty?
  puts
  puts("Failed examples:")
  puts
  failures_and_errors.each do |fail|
    print(Spec.color("crystal spec #{Spec.relative_file(fail.file)}:#{fail.line}", :error))
    puts(Spec.color(" # #{fail.description}", :comment))
  end
end
}
@@instance = new RootContext
@@contexts_stack: Context[] = [@@instance]
describe(description, file, line) {
let describe: Crystal::Call = new Spec.NestedContext(description, file, line, @@contexts_stack.last)
@@contexts_stack.push(describe)
for (__arg4 of Spec.formatters()) {
__arg4.push(describe)
}
block.call()
for (__arg5 of Spec.formatters()) {
__arg5.pop()
}
@@contexts_stack.pop()
}
matches?(description, pattern, line, locations) {
@@contexts_stack.any?(&.matches?(pattern, line, locations)) || (description =~ pattern)
}
matches?(pattern, line, locations) {
false
}
}
class NestedContext extends Context {
getter(parent : Context)
getter(description : String)
getter(file : String)
getter(line : Int32)
constructor(description: string, file, line, parent) {
this.description = description
this.file = file
this.line = line
this.parent = parent
}
report(result) {
@parent.report(Result.new(result.kind, "#{@description} #{result.description}", result.file, result.line, result.elapsed, result.exception))
}
matches?(pattern, line, locations) {
if (@description =~ pattern) {
return true
}
if (@line == line) {
return true
}
if (locations) {
lines = locations[@file]?
unless lines
  return true
end
return lines.includes?(@line)

}
false
}
}}