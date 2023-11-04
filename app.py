import streamlit as st
import pandas as pd
import folium
from folium import plugins
import branca
import webbrowser
from streamlit_folium import st_folium
from st_aggrid import AgGrid
from st_aggrid.grid_options_builder import GridOptionsBuilder


# Load data
ev_stations = pd.read_csv("data/shiny/ev_stations_davidson_.csv")

#davidson_metro = pd.read_csv("data/shiny/davidson.metro.csv")

# Define color mapping for charger types
charger_type_colors = {
    "Airport": "darkgreen",
    "Apartment complex": "gray",
    "Car dealer": "green",
    "Grocery store": "orange",
    "Hospital": "red",
    "Metro": "chocolate",
    "Tesla": "azure",
    "Paid Parking": "cornflowerblue",
}

# Streamlit App
st.title("Find EV Chargers in Nashville")

# Create a map centered around Nashville, Tennessee
m = folium.Map(location=[36.1627, -86.7816], zoom_start=10)

# Add filter by charger type
charger_type = st.sidebar.selectbox(
    "Select charger type", ["All"] + list(charger_type_colors.keys())
)

# Filter the data
if charger_type != "All":
    ev_stations = ev_stations[ev_stations["charger_type"] == charger_type]

# Add markers for EV charging stations
for index, row in ev_stations.iterrows():
   folium.Marker(
       location=[row["latitude"], row["longitude"]],
       popup=f"<strong>{row['station_name']}</strong><br>Address: {row['street_address']}<br>Number of Outlets: {row['num_outlets']}"#,
#       icon=folium.Icon(color=charger_type_colors[row["charger_type"]]),
   ).add_to(m)

# Display the map
st_folium(m, width=1000, height=500)

# Keey the following columns: station_name, street_address, num_outlets, charger_type
ev_stations = ev_stations[["station_name", "street_address", "num_outlets", "charger_type"]]

# Sort by number of outlets
ev_stations = ev_stations.sort_values("num_outlets", ascending=False)

ev_stations = ev_stations.rename(
    columns={
        "station_name": "Station Name",
        "street_address": "Address",
        "num_outlets": "Number of Outlets",
        "charger_type": "Charger Type",
    }
)

# Create a grid option builder
gb = GridOptionsBuilder.from_dataframe(ev_stations)

# Customize grid options as needed
gb.configure_grid_options(domLayout='autoHeight')
gridOptions = gb.build()

# Display the table with streamlit-aggrid
AgGrid(ev_stations, gridOptions=gridOptions, enable_enterprise_modules=True)


#st.write(ev_stations)


# Add a link to Google Analytics
#link = """<a href="https://www.google-analytics.com" target="_blank">Visit Google Analytics</a>"""
#st.markdown(link, unsafe_allow_html=True)
