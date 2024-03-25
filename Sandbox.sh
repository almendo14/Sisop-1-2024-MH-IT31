#!/bin/bash

csv_file="Sandbox.csv"
top_customer=$(awk -F',' '{sales[$6]+=$17} END {for (customer in sales) print customer "," sales[customer]}' "$csv_file" | sort -t',' -k2,2nr | head -n1)

top_customer_name=$(echo "$top_customer" | cut -d',' -f1)
top_customer_sales=$(echo "$top_customer" | cut -d',' -f2)

echo "Pembeli dengan total penjualan tertinggi adalah: $top_customer_name"
echo "Total penjualan: $top_customer_sales"

awk -F ',' 'NR>1 {profits[$7]+=$20} END {for (segment in profits) print segment "," profits[segment]}' Sandbox.csv |
sort -t',' -k2,2n |
head -n 1 |
awk -F ',' '{print "Customer segment dengan profit paling kecil adalah:", $1, "dengan profit:", $2}'

awk -F ',' 'NR>1 {profits[$6]+=$4-$5} END {for (category in profits) print category "," profits[category]}' Sandbox.csv |
sort -t',' -k2,2nr |
head -n 3 |
awk -F ',' '{print "Kategori:", $1, "dengan total profit:", $2}'
