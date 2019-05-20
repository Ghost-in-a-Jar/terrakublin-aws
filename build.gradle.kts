val ktorVersion = "1.2.0"

repositories {
    google()
    jcenter()
    mavenCentral()
}


plugins {
    application
    kotlin("jvm") version "1.3.10"
}

application {
    applicationName = "terrakublin-aws"
    group = "com.terrakublin-aws"
    mainClassName = "com.terrakublin-aws.Application.main"
}

dependencies {

    fun ktor(s: String = "", v: String = ktorVersion) = "io.ktor:ktor$s:$v"
    compile(ktor())
    compile(ktor("-gson"))
    compile(ktor("-html-builder"))
    compile(ktor("-server-netty"))
    compile("ch.qos.logback:logback-classic:1.2.1")
    testImplementation("io.kotlintest:kotlintest-runner-junit5:3.3.2")

    testCompile(ktor("-server-test-host"))
    testCompile("junit:junit:4.12")
}

val test by tasks.getting(Test::class) {
    useJUnitPlatform { }
}
