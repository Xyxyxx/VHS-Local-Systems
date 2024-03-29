import itertools
import pickle
# make a class for parabolic bundles
# here we start with the simple case of 1-1-1-...-1
class Parabolic:
    def __init__(self, degs, weights):
        self.degs = degs # tuple/array of degrees
        self.weights= weights # dictionary of weights associated to 3 marked points 0, 1, infty

    def pardeg(self):
        sum_of_weights = 0
        for point in self.weights:
            sum_of_weights += sum(self.weights[point])
        return sum(self.degs) + sum_of_weights

    def check_stab(self):
        N = len(self.degs)

        # generating and checking the subbundle
        for p in range(N):
            sub_degs = self.degs[0::p + 1]
            sub_weights = dict()
            for key in self.weights:
                sub_weights[key] = self.weights[key][0::p + 1]
            subbundle = Parabolic(sub_degs, sub_weights)
            if subbundle.pardeg() < self.pardeg():
                print("This bundle is not stable!")
                return false
        print("This bundle is stable!")
        return true

    def check_deg_zero(self):
        return self.pardeg() == 0

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
    for i in range(3):
        for a, b, c in itertools.product(range(-4,1), range(-4,1), range(-4,1)):
            degs_array.append((a, b, c))
    
    # now want to make a list of all possible weights
    possible = []
    for a, b, c in itertools.product(range(9), range(9), range(9)):
        possible.append((a/9, b/9, c/9))

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

    #stable_file = open('stable.txt', 'w')
    #unstable_file = open('unstable.txt', 'w')

    stable_file = open('stable.objects', 'wb')
    unstable_file = open('unstable.objects', 'wb')

    #print(bundle_array)
    for bundle in bundle_array:
        if bundle.check_stab():
            # list_stable.append(bundle)
            # stable_file.write(bundle.print())
            pickle.dump(bundle, stable_file)
        else:
            #list_unstable.append(bundle)
            #unstable_file.write(bundle.print())
            pickle.dump(bundle, unstable_file)

    stable_file.close()
    unstable_file.close()
    

if __name__ == "__main__":
	main()
