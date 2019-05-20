import com.terrakublin-aws

import io.ktor.config.MapApplicationConfig
import io.ktor.http.HttpMethod
import io.ktor.server.testing.TestApplicationEngine
import io.ktor.server.testing.handleRequest
import io.ktor.server.testing.withTestApplication
import org.junit.Test
import java.nio.file.Files
import kotlin.test.assertTrue

/**
 * Integration tests for the [main] module.
 */
class ApplicationTest {
    /**
     * Verifies that the [Index] page, returns content with ""
     * for an empty test application.
     */
    @Test
    fun testRootWithoutVideos() = testApp {
        handleRequest(HttpMethod.Get, "/").apply {
            assertTrue { response.content!!.contains("") }
        }
    }
    /**
     * Convenience method we use to configure a test application and to execute a [callback] block testing it.
     */
    private fun testApp(callback: TestApplicationEngine.() -> Unit): Unit {
        val tempPath = Files.createTempDirectory(null).toFile().apply { deleteOnExit() }
        try {
                main()
            }, callback)
        } finally {
            tempPath.deleteRecursively()
        }
    }
}

