def test(a, b, ell):
    return -a + 2 - ell <= 2 * b

def gen_numbers():
    numbers = []
    for a in range(-5,6):
        for b in range(-5, 6):
            numbers.append((a,b))
    return numbers

def main():
    print("Give ell:")
    ell = input()
    nums = gen_numbers()
    for v in nums:
        a = v[0]
        b = v[1]

        print("a:", a, "b:", b)
        tested = test(a, b, ell)
        print("Is -a + 2 - ell <= 2b?", tested)

        if tested:
            print("-a-b:", - a - b)


