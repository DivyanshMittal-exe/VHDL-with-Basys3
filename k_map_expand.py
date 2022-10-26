def binary_to_term(binary_term,updated_term):
    red_term = ""
    
    for id,term_type in enumerate(binary_term):
        if not updated_term[id]:
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
    

        
    term_to_binary = lambda t,s: s if len(t) == 0 else term_to_binary(t[2:],s + '0') if len(t) > 1 and t[1] == "'" else term_to_binary(t[1:],s + '1')
    

    
    if func_TRUE != []:
        n = len(term_to_binary(func_TRUE[0],""))
    elif func_DC != []:
        n = len(term_to_binary(func_DC[0],""))
    else:
        n = 4
    
    all_term_bin = {term_to_binary(term,"") for term in func_TRUE + func_DC}
    

    def get_term_to_combine(term,current_index,updated_term,term_to_yield):
        if current_index >= len(term):
            yield term_to_yield
        elif updated_term[current_index]:
            yield from get_term_to_combine(term,current_index + 1, updated_term, term_to_yield + '0')
            yield from get_term_to_combine(term,current_index + 1, updated_term, term_to_yield + '1')
        else:
            yield from get_term_to_combine(term,current_index + 1, updated_term, term_to_yield + term[current_index])


    
    reduced_terms = []
    
    for term in func_TRUE:
        not_updated_term = [i for i in range(n)]
        updated_term = [False]*n
        binary_term = term_to_binary(term,"")

        while True:
            print(f"Current term expansion: '{binary_to_term(binary_term,updated_term)}'")
            for not_updated_term_index in not_updated_term:
                
                new_binary_term = f"{binary_term[:not_updated_term_index]}{'0' if binary_term[not_updated_term_index] == '1' else '1'}{binary_term[not_updated_term_index+1:]}"
                
                print(f"Next Legal Terms for Expansion for {chr(97 + not_updated_term_index)}:", end = "")
                for term_to_check in get_term_to_combine(new_binary_term,0,updated_term,""):
                    print(f" {binary_to_term(term_to_check,updated_term)}", end = "")
                    if term_to_check not in all_term_bin:
                        print(f"\n{binary_to_term(term_to_check,updated_term)} not present")
                        break
                    print(",",end="")
                else:
                    
                    updated_term[not_updated_term_index] = True   
                    not_updated_term.remove(not_updated_term_index)
                    print(f"\nReduced to {binary_to_term(binary_term,updated_term)}")
                    break
            else:
                break
        
        
        red_term = binary_to_term(binary_term,updated_term)
        print(f"Reduced {term} to {red_term}")
        print()
        print()
                
        reduced_terms.append(red_term)                    
    
    return reduced_terms

if __name__ == "__main__":
    func_TRUE = ["a'b'c'd'e'", "a'b'cd'e", "a'b'cde'", "a'bc'd'e'", "a'bc'd'e", "a'bc'de", "a'bc'de'", "ab'c'd'e'", "ab'cd'e'"]
    func_DC = ["abc'd'e'", "abc'd'e", "abc'de", "abc'de'"]
    
    o = comb_function_expansion(func_TRUE,func_DC)
    print(o)