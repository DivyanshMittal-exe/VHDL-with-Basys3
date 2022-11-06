def binary_to_term(term,mask,n):
    term_str = "{0:b}".format(term).zfill(n)
    term_list = list(term_str)
    mask_str = "{0:b}".format(mask).zfill(n)
    mask_list = list(mask_str)
    
    
    red_term  = ""
    
    for id,term_type in enumerate(term_list):
        if mask_list[id] == "0":
            red_term += chr(97 + id)
            red_term += "'" if term_type == '0' else ""
    

    return red_term

def comb_function_expansion(func_TRUE, func_DC):
    """
    determines the maximum legal region for each term in the K-map function
    Arguments:
    func_TRUE: list containing the terms for which the output is '1'
    func_DC: list containing the terms for which the output is 'x'
    Return:
    a list of terms: expanded terms in form of boolean literals
    """
    

        
    term_to_binary = lambda t,s: s if len(t) == 0 else term_to_binary(t[2:],s << 1) if len(t) > 1 and t[1] == "'" else term_to_binary(t[1:],(s << 1) + 1)
    
    
    if func_TRUE != []:
        n = len(func_TRUE[0]) - func_TRUE[0].count("'")
    elif func_DC != []:
        n = len(func_DC[0]) - func_DC[0].count("'")
    else:
        n = 4
    
    
    all_term_bin = [(term_to_binary(term,0),0) for term in func_TRUE + func_DC]
    # all_true_bin = [term_to_binary(term,0) for term in func_TRUE]
    

    term_all = [all_term_bin]
    
    reduced_terms = []
    
    
    
    while True:
        terms_under_consideration = term_all[-1]
        new_term_list = []
        new_term_set = set()
        for i in range(len(terms_under_consideration)):
            for j in range(i):
                t1 , t1_mask = terms_under_consideration[i]
                t2 , t2_mask = terms_under_consideration[j]
                
                if t1_mask == t2_mask:
                
                    diff = (t1) ^ (t2)
                    
                    if diff & (diff -1) == 0:
                        term_to_add = ((t1 | diff), (t1_mask | diff))
                        if term_to_add not in new_term_set:
                            new_term_list.append(term_to_add)
                            new_term_set.add(term_to_add)
        
        if new_term_list == []:
            break
        
        new_list_str = [binary_to_term(term,mask,n) for (term,mask) in new_term_list]
        l_s = len(new_list_str[0]) - new_list_str[0].count("'")
        print(f"Reductions with {l_s} literals")
        print(new_list_str)
        
        term_all.append(new_term_list)
    
    for t_term,_ in all_term_bin:
                    
        am_i_done = False
        for term_list in reversed(term_all):
            for (term,mask) in term_list:
                
                if (t_term | mask) == term:
                    am_i_done = True
                    reduced_terms.append((term,mask))
                    break
            
            if am_i_done:
                break
    
    def term_sotter(term_mask_pair):
        _,mask = term_mask_pair
        count = 0
        for i in range(n):
            if mask & 1 << i:
                count += 1
        return count
    
    reduced_terms.sort(key= term_sotter, reverse=True)
    
    did_i_reduce = True
    reduced_list = []
    
    
    while did_i_reduce:
        term_m,mask_m = reduced_terms.pop(0)
        reduced_list.append((term_m,mask_m))
        new_red_term = []
        did_i_reduce = False
        for term,mask in reduced_terms:
            if term_m | mask_m != term | mask:
                new_red_term.append((term,mask))
                did_i_reduce = True
        reduced_terms = new_red_term
        print(reduced_terms)


    occourence_count = {}

    all_t_bin = [(term_to_binary(term,0),0) for term in func_TRUE]
    all_dc_bin = [(term_to_binary(term,0),0) for term in func_DC]

    for term,_ in all_dc_bin:
        occourence_count[term] = len(reduced_list) + 1

    for term,_ in all_t_bin:
        for (min_term,min_mask) in reduced_list:
            if (term | min_mask) == min_term:
                if term in occourence_count:
                    occourence_count[term] += 1
                else:
                    occourence_count[term] = 1
    
    
    def get_term_in_minterm(term_list,mask_list,index,term_to_yield):
        if index >= len(term_list):
            yield int(term_to_yield, base=2)
        elif mask_list[index] == '1':
            yield from get_term_in_minterm(term_list,mask_list,index + 1, term_to_yield + '0')
            yield from get_term_in_minterm(term_list,mask_list,index + 1, term_to_yield + '1')
        else:
            yield from get_term_in_minterm(term_list,mask_list,index + 1, term_to_yield + term_list[index])

    
    reduced_list_no_crossover = []
    
    all_t_bin_set = {(term_to_binary(term,0),0) for term in func_TRUE}
    
    def term_sotter_1_count(term_mask_pair):
        
        
        min_term,mask = term_mask_pair
        
        term_str = "{0:b}".format(min_term).zfill(n)
        term_list = list(term_str)
        mask_str = "{0:b}".format(mask).zfill(n)
        mask_list = list(mask_str)
        
        count = 0
        
        for term in get_term_in_minterm(term_list,mask_list,0,""):
            if term in all_t_bin_set:
                count += 1
        return count
    
    reduced_list.sort(key= term_sotter_1_count)
    
    
    for min_term,mask in reduced_list:
        term_str = "{0:b}".format(min_term).zfill(n)
        term_list = list(term_str)
        mask_str = "{0:b}".format(mask).zfill(n)
        mask_list = list(mask_str)
        
        for term in get_term_in_minterm(term_list,mask_list,0,""):
            if occourence_count[term] == 1:
                reduced_list_no_crossover.append((min_term,mask))
                break
                
            if occourence_count[term] == 0:
                print(f"LOG {term}")
                
        else:
            for term in get_term_in_minterm(term_list,mask_list,0,""):
                occourence_count[term] -= 1
            
            
    
    print([binary_to_term(term,mask,n) for (term,mask) in reduced_list_no_crossover])
    
    
    reduced_list_no_crossover = [binary_to_term(term,mask,n) for (term,mask) in reduced_list_no_crossover]
    
    return reduced_list_no_crossover

if __name__ == "__main__":
    func_TRUE = ["a'b'c'd'e'", "a'b'cd'e", "a'b'cde'", "a'bc'd'e'", "a'bc'd'e", "a'bc'de", "a'bc'de'", "ab'c'd'e'", "ab'cd'e'"]
    func_DC = ["abc'd'e'", "abc'd'e", "abc'de", "abc'de'"]
    
    print("Final output")
    o = comb_function_expansion(func_TRUE,func_DC)
    print(o)