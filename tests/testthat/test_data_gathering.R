# tests for functions responsible for data gathering and transformation

context("\ntools")


context("jsons_to_df()")
json_good      <- '{"daily_views": {"2015-03-09": 17682162, "2015-03-08": 16512933, "2015-03-11": 16281862, "2015-03-01": 15898162, "2015-03-03": 17459737, "2015-03-02": 17354278, "2015-03-05": 15621301, "2015-03-04": 16879544, "2015-03-07": 16178753, "2015-03-06": 14515289, "2015-03-12": 14307397, "2015-03-10": 17380958}, "project": "en", "month": "201503", "rank": 2, "title": "main_page"}'
json_good_list <- list(json_good, json_good)
json_bad       <- "{{ {{  {!'§$%%§%' rubbish"
json_bad_list  <- list(json_good, "{{ {{  {!'§$%%§%' rubbish", json_good)

test_that("jsons_to_df() works as expected", {
  expect_error(jsons_to_df())
  expect_is(
    jsons_to_df(json_good, "testpage"),
    "data.frame"
    )
  expect_is(
    jsons_to_df(json_good_list, "testpage"),
    "data.frame"
    )
  expect_is(
    jsons_to_df(list(), "testpage"),
    "data.frame"
    )
  expect_warning(
    jsons_to_df(json_bad, "testpage")
    )
  expect_warning(
    jsons_to_df(json_bad_list, "testpage")
    )
})



context("http_header()")

test_that("http_header() produces something", {
  expect_is(
    http_header(),
    "list")
  expect_true(
    names(http_header())=="user-agent"
    )
  expect_true(
    length(http_header())==1
  )
})












