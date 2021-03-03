/**************************** REXX *********************************/
"FREE FI(outdd)"
"ALLOC FI(outdd) DA('Z05434.OUTPUT(CUST16)') SHR REUSE"
return_code = 0                /* Initialize return code           */
out_ctr = 0                    /* Initialize # of lines written    */


DO j=1 TO 500 BY 1
  CALL GENERATE
  newnum = RESULT
  say newnum
  out.1 = "000" || newnum
  "EXECIO 1 DISKW outdd (STEM out." /* Write it to outdd   */
  out_ctr = out_ctr + 1        /* Increment output line ctr */
END
IF out_ctr > 0 THEN             /* Were any lines written to outdd?*/
  DO                               /* Yes.  So outdd is now open   */

  "EXECIO 0 DISKW outdd (FINIS" /* Closes the open file, outdd     */
  SAY 'File ' outdd ' now contains ' out_ctr' lines.'
END
ELSE                         /* Else no new lines have been        */
                             /* written to file outdd              */
  DO                         /* Erase any old records from the file*/

   /****************************************************************/
   /* Since the outdd file is still closed at this point, the      */
   /* following "EXECIO 0 DISKW " command will open the file,   */
   /* write 0 records, and then close it.  This will effectively   */
   /* empty the data set allocated to outdd.  Any old records that */
   /* were in this data set when this exec started will now be     */
   /* deleted.                                                     */
   /****************************************************************/

   "EXECIO 0 DISKW outdd (OPEN FINIS"  /*Empty the outdd file      */
   SAY 'File ' outdd ' is now empty.'
   END
"FREE FI(outdd)"
EXIT

GENERATE:
  ccnum = ""
  sum = 0
  do i=1 to 15 by 1
      digit = RANDOM(1,9)
      char = D2C(digit +240)
      ccnum = ccnum || char

      if (i//2 == 0) then
          do
              sum = digit + sum
          end
      else
          do
              digit = digit*2
              if (digit > 9) then
                  do
                      digit = digit - 9
                  end
              sum = digit +sum
          end
  end
  if (sum//10 == 0) then
    do
      check = 0
    end
  else
    do
      check = 10 - sum//10
    end
  ccnum = ccnum || D2C(check+240)
RETURN ccnum
