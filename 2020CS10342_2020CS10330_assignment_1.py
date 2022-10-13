import math


# Gets the grey-code list for n bits
def get_grey_code(size):
    if size == 0:
        return ['']
    
    smaller_grey_code = get_grey_code(size - 1)
    
    forward_list = smaller_grey_code
    backward_list = smaller_grey_code[::-1] #Reverse the list
    
    final_list = []
    
    for ele in forward_list:
        new_ele = f"0{ele}"
        final_list.append(new_ele)

    for ele in backward_list:
        new_ele = f"1{ele}"
        final_list.append(new_ele)
        
    return final_list #Final list in 0 prepended to the forward list and 1 to the reverse of it for size n-1, to get size n


def is_legal_region(kmap_function, term):
    """
        determines whether the specified region is LEGAL for the K-map function
        Arguments:
        kmap_function: n * m list containing the kmap function
        for 2-input kmap this will 2*2
        3-input kmap this will 2*4
        4-input kmap this will 4*4
        term: a list of size k, where k is the number of inputs in function (2,3 or 4)
        (term[i] = 0 or 1 or None, corresponding to the i-th variable)
        Return:
        three-tuple: (top-left coordinate, bottom right coordinate, boolean value)
        each coordinate is represented as a 2-tuple
    """
    
    n = (float)(len(term)) # No of terms
    
    is_term_legal = True

    
    all_terms = ['']
    
    # Expand all the terms to the explicit form, that is for example ac = abc + ab'c
    
    for var in term:
        all_items_new = []
        if var != None:
            for term in all_terms:
                term_n = f"{term}{var}"
                all_items_new.append(term_n)
        else:
            for term in all_terms:
                term0 = f"{term}0"
                term1 = f"{term}1"
                all_items_new.append(term0)
                all_items_new.append(term1)
                
        all_terms = all_items_new
    

    
    col_size = math.ceil(n/2)
    row_size = math.floor(n/2)
            
    #Get grey code list for the column size and row size
    gcode_col = get_grey_code(col_size)
    gcode_row = get_grey_code(row_size)
    
    
    
    all_row_indices = []
    all_col_indices = []
    
    for term in all_terms:
        col_term = term[:col_size]
        row_term = term[col_size:]
        
        #Map the term to its column index
        col_index = gcode_col.index(col_term)
        #Map the term to its row index
        row_index = gcode_row.index(row_term)
        
        
        # Check if term is legal
        if kmap_function[row_index][col_index] == 0:
            is_term_legal = False
        
        #Keep track of all row indices used
        if row_index not in all_row_indices:
            all_row_indices.append(row_index)
        
        #Keep track of all col indices used
        if col_index not in all_col_indices:
            all_col_indices.append(col_index)
            
    
    all_row_indices.sort()
    all_col_indices.sort()
    
    
    row_rev = False
    col_rev = False
    
    #If all indices between min and max there, implies no wrapping around
    for i in range(all_row_indices[0],all_row_indices[-1] + 1):
        if i not in all_row_indices:
            row_rev = True
            break
    
    for i in range(all_col_indices[0],all_col_indices[-1] + 1):
        if i not in all_col_indices:
            col_rev = True
            break
    
    
    first_row  = all_row_indices[0]
    second_row  = all_row_indices[-1]
    
    first_col  = all_col_indices[0]
    second_col  = all_col_indices[-1]
    
    #Swaps based on if normal box or wrap around
    if row_rev:
        first_row,second_row = second_row,first_row
        
    if col_rev:
        first_col,second_col = second_col,first_col
        
    return (first_row,first_col), (second_row,second_col), is_term_legal
        
    
#If running the code directly, some basic test, proper testing done using testing.py
if __name__ == '__main__':
    kmap = [[0,1,1,0], ['x',1,'x',0], [1,0,0,0], [1,'x',0,0]]
    term = [None, 1, 0, None]
    print(is_legal_region(kmap_function=kmap,term=term))
    
    term = [None, 0, 1, 0]
    print(is_legal_region(kmap_function=kmap,term=term))
    