import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import com.intuit.karate.junit5.Karate;

class KarateBasicTest {
    static {
        System.setProperty("karate.ssl", "true");
    }
    @Karate.Test
    Karate testBasic() {
        return Karate.run("classpath:karate-test.feature").tags("jvargasn");

    }

}
