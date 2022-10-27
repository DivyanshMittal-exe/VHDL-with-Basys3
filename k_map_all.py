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
    all_true_bin = [term_to_binary(term,0) for term in func_TRUE]
    
    

    # def get_term_to_combine(term,current_index,updated_term,term_to_yield):
    #     if current_index >= len(term):
    #         yield term_to_yield
    #     elif updated_term[current_index]:
    #         yield from get_term_to_combine(term,current_index + 1, updated_term, term_to_yield << 1)
    #         yield from get_term_to_combine(term,current_index + 1, updated_term, (term_to_yield << 1) + 1)
    #     else:
    #         yield from get_term_to_combine(term,current_index + 1, updated_term, (term_to_yield << 1) + term[current_index])

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
        
        term_all.append(new_term_list)
    
    for t_term in all_true_bin:
                    
        am_i_done = False
        for term_list in reversed(term_all):
            for (term,mask) in term_list:
                
                if (t_term | mask) == term:
                    am_i_done = True
                    reduced_terms.append((term,mask))
                    break
            
            if am_i_done:
                break
        
    reduced_terms = [binary_to_term(term,mask,n) for (term,mask) in reduced_terms]
    
    return reduced_terms

if __name__ == "__main__":
    func_TRUE = ["a'b'c'd'e'", "a'b'cd'e", "a'b'cde'", "a'bc'd'e'", "a'bc'd'e", "a'bc'de", "a'bc'de'", "ab'c'd'e'", "ab'cd'e'"]
    func_DC = ["abc'd'e'", "abc'd'e", "abc'de", "abc'de'"]
    
    o = comb_function_expansion(func_TRUE,func_DC)
    print(o)