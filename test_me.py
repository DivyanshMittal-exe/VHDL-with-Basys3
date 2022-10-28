import random
from k_map_all import comb_function_expansion

def binary_to_term(term):
    red_term  = ""
    
    for id,term_type in enumerate(term):
            red_term += chr(97 + id)
            red_term += "'" if term_type == '0' else ""
    

    return red_term

all_ones = []
all_dc = []
all_sol = []

for _ in range(10):
    n = random.randrange(5,10)

    no_of_terms = random.randrange(1,2**n)

    ones = []
    dc = []
    for i in range(no_of_terms):
        term = ["0" if random.random() < 0.5 else "1" for _ in range(n)]
        if term not in ones and term not in dc:
            if random.random() < 0.5:
                ones.append(term)
            else:
                dc.append(term)
        

    dc = [binary_to_term(t) for t in dc]        
    ones = [binary_to_term(t) for t in ones]       

    sol = comb_function_expansion(ones,dc)

    all_ones.append(ones)
    all_dc.append(dc)
    all_sol.append(sol)
    
print(f"ones = {all_ones}")
print(f"dc = {all_dc}")
print(f"sol = {all_sol}")



# with open("s.txt","w") as f:
    # f.write(str(zip(all_ones,all_dc,all_sol)))
 