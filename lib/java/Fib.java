class Fib {
    public static int fib(int a) {
        if (a < 2)
            return a;
        else
            return fib(a-1) + fib(a - 2);
    }
}
