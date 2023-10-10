; 声明一个函数 fib(n)，计算第 n 个斐波那契数
define i32 @fib(i32 %n) {
  entry:
    ; 检查 n 是否小于等于 1，如果是，则返回 n
    %is_less_than_or_equal_to_1 = icmp sle i32 %n, 1
    br i1 %is_less_than_or_equal_to_1, label %if_result, label %else

  else:
    ; 当 n 大于 1 时，计算第 n 个斐波那契数
    %n_minus_1 = sub i32 %n, 1
    %n_minus_2 = sub i32 %n, 2

    ; 递归调用 fib 函数来计算第 n-1 和 n-2 个斐波那契数
    %fib_n_minus_1 = call i32 @fib(i32 %n_minus_1)
    %fib_n_minus_2 = call i32 @fib(i32 %n_minus_2)

    ; 计算第 n 个斐波那契数并返回
    %fib_result = add i32 %fib_n_minus_1, %fib_n_minus_2
    br label %if_result

  if_result:
    ; 返回计算结果
    ret i32 %fib_result
}

; 声明主函数 main
define i32 @main() {
  entry:
    ; 调用 fib 函数计算前 10 个斐波那契数并输出
    %fib_0 = call i32 @fib(i32 0)
    %fib_1 = call i32 @fib(i32 1)
    %fib_2 = call i32 @fib(i32 2)
    %fib_3 = call i32 @fib(i32 3)
    %fib_4 = call i32 @fib(i32 4)
    %fib_5 = call i32 @fib(i32 5)
    %fib_6 = call i32 @fib(i32 6)
    %fib_7 = call i32 @fib(i32 7)
    %fib_8 = call i32 @fib(i32 8)
    %fib_9 = call i32 @fib(i32 9)

    ; 输出结果
    %result = add i32 %fib_0, %fib_1
    %result = add i32 %result, %fib_2
    %result = add i32 %result, %fib_3
    %result = add i32 %result, %fib_4
    %result = add i32 %result, %fib_5
    %result = add i32 %result, %fib_6
    %result = add i32 %result, %fib_7
    %result = add i32 %result, %fib_8
    %result = add i32 %result, %fib_9

    ; 返回主函数结果
    ret i32 %result
}

; 运行主函数
define i32 @__main__() {
  entry:
    %main_result = call i32 @main()   ; 调用主函数 main
    ret i32 %main_result               ; 返回主函数的结果
}

; 这是一个特殊的全局声明，用于指定程序的入口点
; 在LLVM中，入口点默认为__main__函数
@llvm.global_ctors = appending global [0 x { i32, void ()*, i8* }] []
@llvm.global_dtors = appending global [0 x { i32, void ()*, i8* }] []

attributes #0 = { noinline nounwind optnone sspstrong uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"LLVM 11.1.0"}
