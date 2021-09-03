# Fibonacci numbers module

def fib(n):
    """
    Returns the Fibonacci number corresponding to index 'n'
    """
    if (0 <= n <= 1):
        return n
    elif (n > 1):
        return fib(n - 1) + fib(n - 2)
    else:
        raise ValueError()

def fib_sequence(n):
    """
    Prints Fibonacci series up to the n-th element
    """
    result = []
    for idx in range(n + 1):
        result.append(fib(idx))

    return result

#def fib_sequence(n):
#    """
#    Prints Fibonacci series up to the n-th element
#    """
#    a, b = 0, 1
#
#    while a < n + 1:
#        print(a, end=' ')
#        a, b = b, a + b
#
#    print()

#def fib_sequence_list(n):
#    """
#    Returns Fibonacci series up to the n-th element
#    """
#    result = []
#    a, b = 0, 1
#
#    while a < n:
#        result.append(a)
#        a, b = b, a + b
#
#    return result

