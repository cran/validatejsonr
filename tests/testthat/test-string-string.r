testthat::context("Validate JSON string-string IO")

validjson       <- system.file("extdata", "item-3.json", package = "validatejsonr")
schemafile      <- system.file("extdata", "schema.json", package = "validatejsonr")
invalidjsonfn1  <- system.file("extdata", "item-1.json", package = "validatejsonr")
invalidjsonfn2  <- system.file("extdata", "item-2.json", package = "validatejsonr")
malformedjsonfn <- system.file("extdata", "malformed-json.json", package = "validatejsonr")
schema_code     <- readChar(schemafile, file.info(schemafile)$size)

testthat::test_that("validate valid", {  
  json_code <- readChar(validjson, file.info(validjson)$size)
  validate_result <- validate_json_with_schema(json_code, schema_code)
  testthat::expect_that(validate_result$value, equals(0))
})

testthat::test_that("validate malformed", {  
  invalidjson1 <- readChar(invalidjsonfn1, file.info(invalidjsonfn1)$size)
  malformedjson <- readChar(malformedjsonfn, file.info(malformedjsonfn)$size)
  testthat::expect_that(validate_json_with_schema(invalidjson1, schema_code), equals(list(value=100,message="JSON Input is not well-formed JSON. Error(offset 14): Invalid value.", schema=schema_code, jsonfile=invalidjson1)))
  testthat::expect_that(validate_json_with_schema(malformedjson, schema_code)$message, equals("JSON Input is not well-formed JSON. Error(offset 12): Missing a colon after a name of object member."))
})

testthat::test_that("validate invalid", {  
  invalidjson2 <- readChar(invalidjsonfn2, file.info(invalidjsonfn2)$size)
  testthat::expect_that(validate_json_with_schema(invalidjson2, schema_code), equals(list(value=200,message="Invalid schema point: #Invalid keyword: required Invalid document point: #", schema=schema_code, jsonfile=invalidjson2)))
})