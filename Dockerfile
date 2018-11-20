ARG VERSION=latest
FROM python:${VERSION}

RUN echo "Installing unzip and qpdf"
RUN apt update;apt -y install unzip qpdf
RUN mkdir /opt/pdftools/
WORKDIR /opt/pdftools/
RUN echo "Installing pdf-parser & pdfid"
RUN wget http://didierstevens.com/files/software/pdf-parser_V0_6_9.zip; unzip pdf-parser_V0_6_9.zip 
RUN wget http://didierstevens.com/files/software/pdfid_v0_2_5.zip; unzip pdfid_v0_2_5.zip
RUN rm pdfid_v0_2_5.zip pdf-parser_V0_6_9.zip
RUN echo "Copying run.sh"
COPY run.sh /opt/pdftools/
COPY run2.sh /opt/pdftools/
RUN echo "Done"
