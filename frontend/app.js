async function fetchData() {
    try {
        const response = await fetch("http://localhost:5000/api/health");
        const data = await response.json();

        document.getElementById("result").innerText =
            JSON.stringify(data, null, 2);
    } catch (error) {
        document.getElementById("result").innerText =
            "Error connecting to backend";
    }
}