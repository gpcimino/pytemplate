import unittest


from pytemplate.fizzbuzz import FizzBuzz

class TestFizzBuzz(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        pass


    def setUp(self):
        self.results16 = [
            "1",
            "2",
            "fizz",
            "4",
            "buzz",
            "fizz",
            "7",
            "8",
            "fizz",
            "buzz",
            "11",
            "fizz",
            "13",
            "14",
            "fizzbuzz",
            "16"
        ]

    def test_16_numbers(self):
        self.assertEqual(FizzBuzz(16).items(), self.results16)


    def tearDown(self):
        pass


    @classmethod
    def tearDownClass(cls):
        pass
