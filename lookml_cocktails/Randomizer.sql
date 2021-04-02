The requirement was to get a random sample from hundreds of thousands of rows.
The idea is to generate a random number to sort the result set then apply a limit to get a random sample.

Example 1. 

1.1 This returns a uniformly random number in the inclusive range [min,max]

  dimension: uniform_random_sample {
    type: number
    sql: uniform(0,100000, random())  ;;
  }

1.2 Sort the data set then add a filter using uniform_random_sample to limit the value to a sample size.


Example 2. If the sample needs to be taken from a combination of columns, I devised a not-so-uniform way of getting a sample.

2.1 Generate a rank in the PDT based on multiple columns then order by an ETL process table_id

  dimension: rank_account {
    type: number
    sql: ${TABLE}."RNK" ;;
  }

2.2 Use mod to get a 0 remainder on a row and use that as a filter. In this example, if the total number of rows is less than 10, I show all the rows.

  dimension: mod_account {
    type: number
    description:
    "If rank < 10, 0;
    If 10<rank<100, 0 in every 10th record;
    If 100<rank<1000, 0 in every 100th record;
    If 1000<rank<10000, 0 in every 1,000th record
    If 10000<rank<100000, 0 in every 10,000th record"
    sql: case
          when len(${rank_account}) >=5 then mod(${rank_account},10000)
          when len(${rank_account}) >=4 then mod(${rank_account},1000)
          when len(${rank_account}) >=3 then mod(${rank_account},100)
          when len(${rank_account}) >=2 then mod(${rank_account},10)
          when len(${rank_account}) <2 then (${rank_account} - ${rank_account})
         end ;;
  }

  dimension: random_sample {
    type: yesno
    label: "Random Sample"
    sql: ${mod_account} = 0 ;;
  }
