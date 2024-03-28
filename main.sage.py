

# This file was *autogenerated* from the file main.sage
from sage.all_cmdline import *   # import sage library

_sage_const_0 = Integer(0); _sage_const_1 = Integer(1); _sage_const_3 = Integer(3); _sage_const_4 = Integer(4); _sage_const_9 = Integer(9)
import itertools
# make a class for parabolic bundles
# here we start with the simple case of 1-1-1-...-1
class Parabolic:
    def __init__(self, degs, weights):
        self.degs = degs # tuple/array of degrees
        self.weights= weights # dictionary of weights associated to 3 marked points 0, 1, infty

    def pardeg(self):
        sum_of_weights = _sage_const_0 
        for point in self.weights:
            sum_of_weights += sum(self.weights[point])
        return sum(self.degs) + sum_of_weights

    def check_stab(self):
        N = len(self.degs)

        # generating and checking the subbundle
        for p in range(N):
            sub_degs = self.degs[_sage_const_0 ::p + _sage_const_1 ]
            sub_weights = dict()
            for key in self.weights:
                sub_weights[key] = self.weights[key][_sage_const_0 ::p + _sage_const_1 ]
            subbundle = Parabolic(sub_degs, sub_weights)
            if subbundle.pardeg() < self.pardeg():
                print("This bundle is not stable!")
                return false
        print("This bundle is stable!")
        return true

    def check_deg_zero(self):
        return self.pardeg() == _sage_const_0 

    def print(self):
        print("degs:", self.degs, "weights:", self.weights)
        return "degs: " + str(self.degs) + " weights: " + str(self.weights) + "\n"



def main():
    # for now lets check if we can replicate ourselves to a known stable bundle
    # O(-1) + O(-2)
    # alpha'(x) = 7/9, 2/9, 6/9
    # alpha(x) = 6/9, 1/9, 5/9
    '''weights = dict()
    weights['0'] = [7/9, 6/9]
    weights['1'] = [2/9, 1/9]
    weights['infty'] = [6/9, 5/9]
    
    bundle = Parabolic([-1, -2], weights)
    print("Is this bundle stable?", bundle.check_stab())
    print("Doe this bundle have expected degree?", bundle.pardeg())
    '''
    #points = ['0', '1', 'infty']

    # now we want to maybe try to do something with type 1-1-1
    degs_array = []
    for i in range(_sage_const_3 ):
        for a, b, c in itertools.product(range(-_sage_const_4 ,_sage_const_1 ), range(-_sage_const_4 ,_sage_const_1 ), range(-_sage_const_4 ,_sage_const_1 )):
            degs_array.append((a, b, c))
    
    # now want to make a list of all possible weights
    possible = []
    for a, b, c in itertools.product(range(_sage_const_9 ), range(_sage_const_9 ), range(_sage_const_9 )):
        possible.append((a/_sage_const_9 , b/_sage_const_9 , c/_sage_const_9 ))

    weights_array = []
    for u in possible:
        wt = dict()
        wt['0'] = u
        for v in possible:
            wt['1'] = v
            for w in possible:
                wt['infty'] = w
        weights_array.append(wt)

    #print(degs_array)
    #print(weights_array)
    

    
    bundle_array = []
    for deg_vec in degs_array:
        for weights_vec in weights_array:
            bundle = Parabolic(deg_vec, weights_vec)
            if bundle.check_deg_zero():
                bundle_array.append(Parabolic(deg_vec, weights_vec))

    list_stable = []
    list_unstable = []

    stable_file = open('stable.txt', 'w')
    unstable_file = open('unstable.txt', 'w')

    #print(bundle_array)
    for bundle in bundle_array:
        if bundle.check_stab():
            list_stable.append(bundle)
            stable_file.write(bundle.print())
        else:
            list_unstable.append(bundle)
            unstable_file.write(bundle.print())

    stable_file.close()
    unstable_file.close()
    

if __name__ == "__main__":
	main()

