FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04

ENV MYSQL_ROOT_HOST=biomedisa_database

RUN apt-get update \
	&& apt-get install -y python3 python3-dev python3-pip \
	&& apt-get install -y libsm6 libxrender-dev libmysqlclient-dev pkg-config \
	&& apt-get install -y libboost-python-dev build-essential screen \
	&& apt-get install -y libssl-dev cmake openmpi-bin openmpi-doc \
	&& apt-get install -y libopenmpi-dev redis-server git libgl1 uuid-runtime

RUN pip install --upgrade pip setuptools testresources scikit-build numpy \
	&& pip install --upgrade scipy h5py colorama wget numpy-stl numba \
	&& pip install --upgrade imagecodecs tifffile scikit-image opencv-python \
	&& pip install --upgrade Pillow nibabel medpy SimpleITK mpi4py itk vtk rq \
	&& pip install --upgrade mysqlclient matplotlib \
	&& pip install django==3.2.6

RUN apt-get install --no-install-recommends libcudnn8=8.8.0.121-1+cuda11.8 \
	&& apt-get install --no-install-recommends libcudnn8-dev=8.8.0.121-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer8=8.5.3-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer-dev=8.5.3-1+cuda11.8 \
	&& apt-get install --no-install-recommends libnvinfer-plugin8=8.5.3-1+cuda11.8

RUN pip install tensorflow==2.13.0 

WORKDIR /home

RUN git clone https://github.com/biomedisa/biomedisa.git

COPY entrypoint.sh /home/biomedisa

RUN chmod +x /home/biomedisa/entrypoint.sh

COPY config.py /home/biomedisa/biomedisa_app/

COPY settings.py /home/biomedisa/biomedisa/

ENTRYPOINT ["/home/biomedisa/entrypoint.sh"]
