# TODO: Like https://nombre.rossellhayes.com/reference/collective.html

# zero = "none"
# inf = "all"
# na = "an unknown amount"
# nan = "an undefined amount"

# TODO: Wait no, this is just a wrapper for `integer_friendly()`, which I don't
# think you need to name.

# nof_friendly(c(0:5, NA))
# "none" "one" "two" "three", "five", "an unknown amount"
# - provide a suffix = "", so you can set to suffix = "of". Or maybe just "of = TRUE/FALSE"
#

# IMPORTANT!!
# TODO: The thing we actually want is `quantity_friendly()`.

# na = "an unknown amount of"
# nan = "an undefined amount of"
# zero = "no"
# 1 -> "a" (could be "the")
# 2 -> "both"
# 3 -> "all three"
# ...
# 1000 -> "all 1,000" (allow a threshold setting)
# Inf -> "all"

# max_friendly = 99 (threshold before we use numbers to describe things)
# - "all ninety-nine" vs. "all 100"
