
select * from dual, lateral split_to_table(regexp_replace('abcde','.',',\\0',2), ',') lat

# lateral keyword allows an inline view to reference columns from a table expression that precedes that inline view
# split_to_table splits a string and flattens the results into rows
# regexp_replace added commas between the characters