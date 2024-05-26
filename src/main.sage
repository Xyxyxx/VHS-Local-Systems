import itertools
import pickle
import math
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


# this spits out a list of tuples of possible degrees for the given
# sum1 = sum of weights of L_1
# sum2 = sum of weights of L_2
# num_poles3 = number of poles of theta_3 : L_3 -> L_2 \otimes \Omega(\log D)
# num_poles2 = number of poles of theta_2 : L_2 -> L_1 \otimes \Omega(\log D)
def possible_degs(sum1, sum2, num_poles3, num_poles2):
    # the conditions needed to satisfy is 
    # sum1 + sum2 < deg1 <= deg2 - 2 + num_poles2 <= d_1 - 4 + num_poles2 + num_poles3 < - sum1 - 4 + num_poles2 + num_poles3
    lowest = math.ceil(sum1 + sum2)
    if lowest == sum1 + sum2:
        lowest = lowest + 1
    highest = math.floor(- sum1 - 4 + num_poles3 + num_poles2)
    if highest == - sum1 - 4 + num_poles2 + num_poles3:
        highest = highest - 1

    # generate all the degrees that satisfy our conditions
    deg_arr = []
    for deg3 in range(lowest, highest + 1):
        for deg2 in range(deg3 + 2 - num_poles2, highest + 1):
            for deg1 in range(deg2 + 2 - num_poles3, highest + 1):
                if deg1 + deg2 + deg3 == 0:
                    deg_arr.append( (deg1, deg2, deg3) ) # tuple of degrees

    return deg_arr

# find array of stable degrees given data of weights and poles
def find_stable(sum1, sum2, ell3, ell2):
    deg_arr = possible_degs(sum1, sum2, ell3, ell2)

    # look through deg_arr and check for stability
    sum3 = - sum1 - sum2 # sum1 + sum2 + sum3 = 0
    # first only take the pardeg 0 stuff
    pardeg_zero_arr = []
    for d in deg_arr:
        #d_1 = d[0]
        #d_2 = d[1]
        #d_3 = d[2]
        pardeg = d[0] + d[1] + d[2] + sum1 + sum2 + sum3
        if pardeg == 0:
            pardeg_zero_arr.append(d)

    stable_arr = []
    for d in pardeg_zero_arr:
        if d[0] + sum1 < 0:
            if d[0] + d[1] + sum1 + sum2 < 0:
                stable_arr.append(d)

    return stable_arr

def main():
    stability_data = dict()
    for sum1 in range(-5, 6):
        for sum2 in range(-5, 6):
            for ell3 in range(0, 4):
                for ell2 in range(0, 4):
                    weight_data = (sum1, sum2, ell3, ell2)
                    stability_data[weight_data] = find_stable(sum1, sum2, ell3, ell2)
    # clean the data
    excise = []
    for key in stability_data:
        if stability_data[key] == []:
            excise.append(key)
    for key in excise:
        print(key)
        stability_data.pop(key)

    A1 = 0
    A2 = 0
    ell3 = 0
    ell2 = 0
    for key in excise:
        A1 = key[0]
        A2 = key[1]
        ell3 = key[2]
        ell2 = key[3]

        if A1 + A2 < -A1 - 4 + ell3 + ell2:
            print(key)
            print("A_1 + A_2:", A1 + A2)
            print("-A_1 - 4 + ell3 + ell2:", -A1 - 4 + ell3 + ell2)

    '''
    for key in stability_data:
        print(key, ":")
        print(stability_data[key])

    '''



 


"""
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
"""

if __name__ == "__main__":
	main()
