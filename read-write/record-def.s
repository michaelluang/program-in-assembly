# PURPOSE: This file stores the offsets of each field from 
#          the beginning of the record.
#          So we will accessing the records using base pointer
#          addressing.
#
# DATA STRUCTURE: These records store some basic information
#                 about great programmers in computer science.
#                 Each record has a fixed-length format:
#                 Firstname - 40 bytes
#                 Lastname  - 40 bytes
#                 Knownfor  - 240 bytes
#                 Age       - 4 bytes

.equ RECORD_FIRSTNAME, 0
.equ RECORD_LASTNAME, 40
.equ RECORD_KNOWNFOR, 80
.equ RECORD_AGE, 320

.equ RECORD_SIZE, 324
