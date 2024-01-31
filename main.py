if 1 == 1:
    from selenium import webdriver
    from selenium.webdriver.chrome.options import Options
    print("Selenium is installed")
    def get_driver():
        print("Starting the WebDriver")
        options = Options()
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")  # Bypass OS security model
        options.add_argument("--disable-dev-shm-usage")  # Overcome limited resource problems
        options.add_argument("--disable-gpu")  # GPU hardware acceleration isn't typically available in containers
        options.add_argument("--disable-extensions")
        options.add_argument("--disable-setuid-sandbox")
        options.add_argument("--ignore-gpu-blocklist")
        options.add_argument("--disable-accelerated-2d-canvas")
        options.add_argument("--remote-debugging-port=9222")

        driver = webdriver.Chrome(options=options)
        return driver

    # Example usage
    driver = get_driver()
    driver.get("http://example.com")
    print(driver.title, flush=True)
    driver.quit()

print("begin loop", flush=True)
import time
while True:
    time.sleep(60)
