# des vhdl implentation

the test vector is pass, so the implementation is correct.

## test vector

Here's a trace through the first block of that, `4E6F772069732074`. The key is `0123456789ABCDEF` and expected ciphertext `3FA40E8A984D4815`:

```plaintext
     input: 4E6F7720-69732074
after perm: B7A48736-00FE1327
==== Round 01/16
  using subkey: 0B02679B49A5
     after xor: 8B159B9120AB
    after sbox: 1B7A1DBA
       after P: 7E4B644F
      xor with: B7A48736
    xor result: C9EFE379
         final: 00FE1327-C9EFE379
==== Round 02/16
  using subkey: 69A659256A26
     after xor: 8C9906D501D5
    after sbox: CF430076
       after P: C2DBC430
      xor with: 00FE1327
    xor result: C225D717
         final: C9EFE379-C225D717
==== Round 03/16
  using subkey: 45D48AB428D2
     after xor: A595815EC07D
    after sbox: 467DACD6
       after P: D71390FD
      xor with: C9EFE379
    xor result: 1EFC7384
         final: C225D717-1EFC7384
==== Round 04/16
  using subkey: 7289D2A58257
     after xor: 7D5E2A9FFE5F
    after sbox: 815B7DE2
       after P: B4D764C9
      xor with: C225D717
    xor result: 76F2B3DE
         final: 1EFC7384-76F2B3DE
==== Round 05/16
  using subkey: 3CE80317A6C2
     after xor: 063FA64DD83E
    after sbox: 08700318
       after P: 0E292004
      xor with: 1EFC7384
    xor result: 10D55380
         final: 76F2B3DE-10D55380
==== Round 06/16
  using subkey: 23251E3C8545
     after xor: 2933B496F945
    after sbox: F053CADD
       after P: 9FF58A23
      xor with: 76F2B3DE
    xor result: E90739FD
         final: 10D55380-E90739FD
==== Round 07/16
  using subkey: 6C04950AE4C6
     after xor: 992C9B95DB3D
    after sbox: 871AC376
       after P: 47F66470
      xor with: 10D55380
    xor result: 572337F0
         final: E90739FD-572337F0
==== Round 08/16
  using subkey: 5788386CE581
     after xor: 7D613EF61A21
    after sbox: 8D9454C2
       after P: 249E5119
      xor with: E90739FD
    xor result: CD9968E4
         final: 572337F0-CD9968E4
==== Round 09/16
  using subkey: C0C9E926B839
     after xor: A5751B93AF30
    after sbox: 4ACA1D90
       after P: 7249A149
      xor with: 572337F0
    xor result: 256A96B9
         final: CD9968E4-256A96B9
==== Round 10/16
  using subkey: 91E307631D72
     after xor: 01485229C880
    after sbox: E212A54D
       after P: 4DD0AAA8
      xor with: CD9968E4
    xor result: 8049C24C
         final: 256A96B9-8049C24C
==== Round 11/16
  using subkey: 211F830D893A
     after xor: 611DD0EDCB63
    after sbox: 5C3145A1
       after P: 840CAC1F
      xor with: 256A96B9
    xor result: A1663AA6
         final: 8049C24C-A1663AA6
==== Round 12/16
  using subkey: 7130E5455C54
     after xor: 211BE95A0959
    after sbox: 2C7AF9D0
       after P: 375D22D5
      xor with: 8049C24C
    xor result: B714E099
         final: A1663AA6-B714E099
==== Round 13/16
  using subkey: 91C4D04980FC
     after xor: 4B2C7939940F
    after sbox: A84C6034
       after P: 028D16E0
      xor with: A1663AA6
    xor result: A3EB2C46
         final: B714E099-A3EB2C46
==== Round 14/16
  using subkey: 5443B681DC8D
     after xor: 043CE0145E80
    after sbox: 0DFA245D
       after P: 0E5949FC
      xor with: B714E099
    xor result: B94DA965
         final: A3EB2C46-B94DA965
==== Round 15/16
  using subkey: B691050A16B5
     after xor: 69BB5EDF3DBE
    after sbox: 998F9E88
       after P: B9E8514B
      xor with: A3EB2C46
    xor result: 1A037D0D
         final: B94DA965-1A037D0D
==== Round 16/16
  using subkey: CA3D03B87032
     after xor: 457D0507D868
    after sbox: AA2BE869
       after P: D9DC0EC4
      xor with: B94DA965
    xor result: 6091A7A1
         final: 1A037D0D-6091A7A1
after perm: 3FA40E8A-984D4815
```
