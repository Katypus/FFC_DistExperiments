FROM r-base:3.4.2
COPY . /wang
WORKDIR /wang
RUN apt-get update 
RUN apt-get install -y libcurl4-openssl-dev=7.58.0-2  
RUN apt-get install -y libssl-dev=1.1.0h-2
RUN Rscript -e "install.packages('readr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
# install readr v. 1.1.1 if necessary

RUN Rscript -e "install.packages('Amelia', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Amelia/Amelia_1.7.4.tar.gz')"

RUN Rscript -e "install.packages('dplyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/dplyr/dplyr_0.7.4.tar.gz')"

RUN Rscript -e "install.packages('tidyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/tidyr/tidyr_0.8.0.tar.gz')"

RUN Rscript -e "install.packages('glmnet', dependencies=TRUE, repos='http://cran.rstudio.com/')"
#install glmnet version 2.0-16 if necessary 

#install foreach version 1.4.4 
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.2-11.tar.gz')"
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Rcpp/Rcpp_0.12.16.tar.gz')" 
CMD ["sh"]
