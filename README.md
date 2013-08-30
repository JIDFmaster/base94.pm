base94.pm
=========

perl version of base 94


Use like this

    perl -e 'use Base94; print Base94::from_base94("y00FYrSxr68dmV8:7509|4PNzv^?")'
    perl -e 'use Base94; print Base94::to_base94("75d939b4ce141c9f0383b9a670c18a3ab23e80bbe40110")'
    
    
warning: 
   from_base94('a').from_base94('b')!= from_base94('ab')

