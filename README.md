# K- Map

In this assignment we will construct and manipulate Karnaugh Maps (K-maps). KMaps represent a function of 2, 3, 4 boolean/binary variables a, b, c, and d. For each
abcd combination, the function can have one of the following values: TRUE (1), FALSE (0), and DON’T CARE (x).
DON’T CARE implies that the output value of the function is not relevant, so can be either 0 or 1

For a K-map with 4 variables, the rows of the K-map are labelled with ab values, and columns are labelled with
cd values. Note the sequence of values [00, 01, 11, 10]. This is a K-map property (adjacent cells have only one
variable changing values).
A REGION in the K-map is identified by two co-ordinates: the top-left corner, and bottom-right corner (note
that the regions can wrap around the edges). Regions correspond to TERMS (e.g., ab'c), which are the product
of LITERALS. Literals can be a boolean variable or its complement (e.g., a or b'). Here is the way to find the
region corresponding to a term.
1. If a variable a appears in uncomplemented form (e.g., ab), then the region has a = 1 in all its cells.
2. If a variable a appears in complemented form (e.g., a'b), then the region has a = 0 in all its cells.
3. If a variable k does not appear in the term, then the region has both cells with k = 0 and cells with k = 1.

Given a function and a term, write a program to:
1. highlight the corresponding K-map region, and
2. report whether the region is LEGAL. A legal region can consist of 1s and x’s, but cannot contain any 0s.