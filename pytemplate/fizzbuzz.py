class Fizz(object):
    def __init__(self, i):
        self.i = i

    def fire(self):
        return self.i % 3 == 0

    def __str__(self):
        if self.fire():
            return "fizz"
        else:
            return ""

class Buzz(object):
    def __init__(self, i):
        self.i = i

    def fire(self):
        return self.i % 5 == 0

    def __str__(self):
        if self.fire():
            return "buzz"
        else:
            return ""

class Number(object):
    def __init__(self, i):
        self.i = i

    def __str__(self):
        return str(self.i)


class Composite(object):
    def __init__(self, buzz, fizz, number):
        self.fizzbuzz = [f for f in [fizz, buzz] if f.fire()]
        self.number = number

    def __repr__(self):
        return self.__str__

    def __str__(self):
        if len(self.fizzbuzz) >  0:
            return "".join([str(f) for f in self.fizzbuzz])
        else:
            return str(self.number)


class FizzBuzz(object):
    def __init__(self, lenght):
        self.lenght = lenght

    def items(self):
        return [str(Composite(Buzz(i), Fizz(i), Number(i))) for i in range(1, self.lenght+1)]

    def __str__(self):
        return "\n".join(self.items())


if __name__ == "__main__":
    print(FizzBuzz(100))

