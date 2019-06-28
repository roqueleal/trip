
f2 = File.open("heatmap_data.js", "w")
f2.write("var taxiData = [new google.maps.LatLng(0,0)")
f2.close

f = File.open("filtered_police_locations.csv", 'w')
f.write("")
f.close

f3 = File.open("marker_data.js", "w")
f3.write("var markerData = [new google.maps.Marker({position: new google.maps.LatLng(0,0)})")
f3.close

File.open("police_locations.csv", 'r').each_line do |line|
  data = line.split(",")
  lat = data[0]
  long = data[1]


# 43.889975,-84.958992

  if long.to_f > -86.479311 && long.to_f < -84.958992 && lat.to_f > 40.043912 && lat.to_f < 45.521744
    f = File.open("filtered_police_locations.csv", 'a')
    f.write(line)
    f.close

    f2 = File.open("heatmap_data.js", 'a')
    f2.write(",")
    f2.write("\n")
    f2.write("new google.maps.LatLng(" + data[0] + ", " + data[1] + ")")
    f2.close

    f3 = File.open("marker_data.js", "a")
    f3.write(",")
    f3.write("\n")
    f3.write("new google.maps.Marker({position: new google.maps.LatLng(" + data[0] + ", " + data[1] + ")")
    if data.count == 3
      f3.write(", title: '" + data[2] + "'")
    end
    f3.write("})")
    f3.close
  end

end
f2 = File.open("heatmap_data.js", 'a')
f2.write("];")
f2.close

f3 = File.open("marker_data.js", 'a')
f3.write("];")
f3.close