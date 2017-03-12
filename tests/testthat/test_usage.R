context("\nstatsgrokse()")

test_that(
  "normal usage", {
    tmp <- statsgrokse("main", from="2015-01-01", to="2015-01-31")
    expect_true( all(dim(tmp) > 0) )
  }
)













