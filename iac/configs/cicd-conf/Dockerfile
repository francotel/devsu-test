FROM public.ecr.aws/amazoncorretto/amazoncorretto:17 AS build
ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar
EXPOSE 8000
ENTRYPOINT ["java","-Dspring.profiles.active=dev,develop","-jar","/app.jar", "-server", "-Xms75m", "-Xms600m", "-XX:+UseG1GC", "-XX:ThreadStackSize=256", "-XX:ConcGCThreads=12", "-XX:ParallelGCThreads=22", "-XX:MaxGCPauseMillis=1000", "-XX:G1HeapWastePercent=2", "-XX:G1ReservePercent=15", "-XX:+UnlockExperimentalVMOptions", "-XX:G1OldCSetRegionThresholdPercent=15", "-XX:G1MixedGCLiveThresholdPercent=90", "-XX:G1NewSizePercent=20"]
RUN mkdir -p /opt/files
ENV TEMP_DIRECTORY /opt/files