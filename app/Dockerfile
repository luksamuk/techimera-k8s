FROM alpine:3.16 AS builder
RUN apk add --no-cache musl-dev build-base libpq libpq-dev postgresql-dev


FROM alpine:3.16
# Install Roswell, SBCL and Qlot
RUN apk add --no-cache \
    --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing roswell \
    && apk add --no-cache make build-base tar libev ca-certificates tzdata libpq \
    && ros install sbcl-bin \
    && ros install qlot \
    && apk del make

ENV TZ=Etc/UTC
ENV PATH=/root/.roswell/bin:$PATH

# Install project dependencies
RUN mkdir /app
WORKDIR /app
COPY ./qlfile ./qlfile
RUN qlot install

# Bootstrap dependencies that are loaded dynamically
COPY . .
RUN echo "Bootstrapping libraries..." \
    && qlot exec ros -- techimera.ros --bootstrap \
    && apk del build-base \
    && echo "Done."

COPY --from=builder /usr/lib/libgcc_s.so.1 /usr/lib/
COPY --from=builder /usr/lib/libgcc_s.so /usr/lib/
COPY --from=builder /usr/lib/libstdc++.so.6.0.29 /usr/lib/
COPY --from=builder /usr/lib/libstdc++.so.6 /usr/lib/
COPY --from=builder /usr/lib/libstdc++.so /usr/lib/

# HTTP Server and Swank for remote REPL
EXPOSE 9000
EXPOSE 4005

ENTRYPOINT ["qlot", "exec", "ros", "--", "techimera.ros", "--swank"]
