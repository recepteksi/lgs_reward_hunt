import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("environment")

    productFlavors {
        create("dev") {
            dimension = "environment"
            applicationId = "com.lgsrewardhunt.app.dev"
            resValue(type = "string", name = "app_name", value = "LGS Ödül Avı Dev")
        }
        create("prod") {
            dimension = "environment"
            applicationId = "com.lgsrewardhunt.app"
            resValue(type = "string", name = "app_name", value = "LGS Ödül Avı")
        }
    }

    buildFeatures.resValues = true
}