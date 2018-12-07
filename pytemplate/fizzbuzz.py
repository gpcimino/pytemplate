class Fizz():
    def __init__(self, i):
        self.i = i

    def fire(self):
        return self.i % 3 == 0

    def __str__(self):
        if self.fire():
            return "fizz"
        return ""

class Buzz():
    def __init__(self, i):
        self.i = i

    def fire(self):
        return self.i % 5 == 0

    def __str__(self):
        if self.fire():
            return "buzz"
        return ""


class Composite():
    def __init__(self, buzz, fizz, number):
        self.fizzbuzz = [f for f in [fizz, buzz] if f.fire()]
        self.number = number

    def __repr__(self):
        return self.__str__

    def __str__(self):
        if len(self.fizzbuzz) >  0:
            return "".join([str(f) for f in self.fizzbuzz])
        return str(self.number)


class FizzBuzz():
    def __init__(self, lenght):
        self.lenght = lenght

    def items(self):
        return [str(Composite(Buzz(i), Fizz(i), i)) for i in range(1, self.lenght+1)]

    def __str__(self):
        return "\n".join(self.items())


if __name__ == "__main__":
    print(FizzBuzz(100))

