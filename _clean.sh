#!/bin/sh
#delete processing results
find . -type f -name "*_??.raw" -delete
find . -type f -name "*_??_????.raw" -delete
find . -type f -name "*_1??.raw" -delete
find . -type f -name "*_1??_????.raw" -delete
find . -type f -name "*_2??.raw" -delete
find . -type f -name "*_2??_????.raw" -delete

