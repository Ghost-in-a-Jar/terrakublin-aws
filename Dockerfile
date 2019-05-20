FROM gradle:jdk8 as builder

RUN gradle build
RUN gradle test

EXPOSE 8080

# We copy the FAT Jar we built into the /app folder and sets that folder as the working directory.
COPY build/libs/terrakublin-aws.jar /app/terrakublin-aws.jar
WORKDIR /app

# We launch java to execute the jar, with good defauls intended for containers.
CMD ["java", "-server", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-XX:InitialRAMFraction=2", "-XX:MinRAMFraction=2", "-XX:MaxRAMFraction=2", "-XX:+UseG1GC", "-XX:MaxGCPauseMillis=100", "-XX:+UseStringDeduplication", "-jar", "my-application.jar"]
