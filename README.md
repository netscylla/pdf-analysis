# pdf-analysis

A simple docker container that make use of [qpdf](https://github.com/qpdf/qpdf) and Didier Stevens [PDF toolkit](https://github.com/DidierStevens/DidierStevensSuite) (pdfid & pdf-parser) to automate the extraction of potenitally malcious URL's from pdf files.  If the pdf is encrypted it will accept a password to attempt decryption, or ommit a password for a simple dictionary attack against the encrypted pdf.

Our **/opt/pdftools/run.sh** script accepts two arguments:
1. filename
1. password (optional)

# Build

```
docker build . -t pdftools:latest
```

# Usage
Example:

Please note we've used the -v (mount volume) flag to share and map our /tmp directory that contains the pdf

```
$ docker run -v /tmp:/tmp -it pdftools:latest /opt/pdftools/run.sh /tmp/Project#1542292355.pdf
No password found, if encrypted may not be able to proceed!
PDF is encrypted...
trying password...
Trying default passwords
/tmp/Project#1542292355.pdf: invalid password
/tmp/Project#1542292355.pdf: invalid password
Valid Password, continuing...
extracting URIs:
https://www.example.com/dir/
```