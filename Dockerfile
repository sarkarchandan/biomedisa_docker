FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

# Specify the host container for the MySQL database server
ENV MYSQL_ROOT_HOST=biomedisa_database
# Countermeasure to deal with ssl verification
# TODO: Check if this can be removed
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# Following environment variables are needed to make sure that
# MPI processes can run as root inside the container.
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python3 python3-dev python3-distutils python3-pip 

RUN apt-get install -y ca-certificates build-essential libssl-dev libffi-dev gnupg \
	&& apt-get install -y libsm6 libxrender-dev libmysqlclient-dev pkg-config \
	&& apt-get install -y libboost-python-dev build-essential screen \
	&& apt-get install -y libssl-dev cmake openmpi-bin openmpi-doc \
	&& apt-get install -y libopenmpi-dev redis-server git libgl1 uuid-runtime \
	&& apt-get install -y apache2 apache2-doc libapache2-mod-wsgi-py3

RUN pip install --upgrade setuptools testresources scikit-build numpy \
	&& pip install --upgrade scipy h5py colorama wget numpy-stl numba \
	&& pip install --upgrade imagecodecs tifffile scikit-image opencv-python \
	&& pip install --upgrade Pillow nibabel medpy SimpleITK mpi4py itk vtk rq \
	&& pip install --upgrade mysqlclient matplotlib certifi pycuda \
	&& pip install django==3.2.6

RUN apt-get install --no-install-recommends libcudnn8=8.8.0.121-1+cuda11.8 \
	&& apt-get install --no-install-recommends libcudnn8-dev=8.8.0.121-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer8=8.5.3-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer-dev=8.5.3-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer-plugin8=8.5.3-1+cuda11.8 \
	&& update-ca-certificates

RUN pip install tensorflow==2.13.0 

WORKDIR /home

RUN git clone https://github.com/biomedisa/biomedisa.git

COPY entrypoint.sh /home/biomedisa

RUN chmod +x /home/biomedisa/entrypoint.sh

COPY config.py /home/biomedisa/biomedisa_app/

COPY settings.py /home/biomedisa/biomedisa/

# TODO: Check if apache web server is needed and if not essential
# remove it.
# Adapt apache web server configuration
COPY 000-default.conf /etc/apache2/sites-available/

RUN chmod -R 750 /home/biomedisa \
#	&& chmod -R 770 /home/biomedisa/private_storage \
	&& chmod -R 770 /home/biomedisa/media \
	&& chmod -R 770 /home/biomedisa/log \
	&& chmod -R 770 /home/biomedisa/tmp

ENTRYPOINT ["/home/biomedisa/entrypoint.sh"]
