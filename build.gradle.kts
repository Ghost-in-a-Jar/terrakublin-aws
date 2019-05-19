val kotlinVersion = "1.3.50"
val ktorVersion = "1.0.0"

repositories {
    google()
    jcenter()
    mavenCentral()
}


plugins {
    application
    kotlin("jvm") version "1.3.10"
    id("com.palantir.docker") version "0.22.1"
    id("com.palantir.docker-run") version "0.22.1"
}

application {
    applicationName = "terrakublin-aws"
    group = "com.terrakublin-aws"
    mainClassName = "com.terrakublin-aws.Application.main"
}

docker {
    name = System.getenv("IMAGE_NAME")
}

dockerRun {
    name = "terrakublin-aws-container"
    image = System.getenv("IMAGE_NAME")
}
dependencies {

    fun ktor(s: String = "", v: String = ktorVersion) = "io.ktor:ktor$s:$v"
    compile(ktor())
    compile(ktor("-gson"))
    compile(ktor("-html-builder"))
    compile(ktor("-server-netty"))
    compile("ch.qos.logback:logback-classic:1.2.1")

    testCompile(ktor("-server-test-host"))
    testCompile("junit:junit:4.12")
}
