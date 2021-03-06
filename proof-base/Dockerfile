# Copyright 2018, OpenSoft Inc.
# All rights reserved.

# Redistribution and use in source and binary forms, with or without modification, are permitted
# provided that the following conditions are met:

#     * Redistributions of source code must retain the above copyright notice, this list of
# conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright notice, this list of
# conditions and the following disclaimer in the documentation and/or other materials provided
# with the distribution.
#     * Neither the name of OpenSoft Inc. nor the names of its contributors may be used to endorse
# or promote products derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
# IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Author: denis.kormalev@opensoftdev.com (Denis Kormalev)

FROM debian:stretch-backports

COPY image_cleaner.sh /image_cleaner.sh
COPY prebuilt/*.deb /prebuilt/

RUN chmod +x /image_cleaner.sh \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends ca-certificates \
    && cd /prebuilt && (dpkg -i *.deb 2> /dev/null || apt-get -qq -f install -y --no-install-recommends) \
    && apt-get -qq install -y --no-install-recommends libqrencode3 libproxy1v5 libproxy1-plugin-webkit \
    && rm /opt/Opensoft/Qt/lib/libQt5Designer* && rm /opt/Opensoft/Qt/bin/designer \
    && rm /opt/Opensoft/Qt/bin/assistant && rm /opt/Opensoft/Qt/bin/linguist \
    && rm /opt/Opensoft/Qt/bin/qdoc && rm -rf /opt/Opensoft/Qt/doc && rm -rf /opt/Opensoft/Qt/share \
    && rm -rf /prebuilt && /image_cleaner.sh

ENV QTDIR=/opt/Opensoft/Qt \
    LD_LIBRARY_PATH=/opt/Opensoft/Qt/lib:$LD_LIBRARY_PATH \
    PKG_CONFIG_PATH=/opt/Opensoft/Qt/lib/pkgconfig:$PKG_CONFIG_PATH \
    PATH=/opt/Opensoft/Qt/bin:$PATH

ENTRYPOINT exec /bin/bash
