import cv2

# Load some pre-trained data on face frontals from opencv (haar cascade algorithm)
trained_face_data = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')#modified by will from stack overflow

# Choose an image to detect faces in
img = cv2.imread('p9.jpg')
    
# Must convert to greyscale
grayscaled_img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
print(grayscaled_img.shape) 
# Detect Faces 
face_coordinates = trained_face_data.detectMultiScale(grayscaled_img)

#img_crop = []

# Draw rectangles around the faces
for (x, y, w, h) in face_coordinates:
    cv2.rectangle(img, (x,y), (x+w, y+h), (0, 255, 0), 2)
    
print(len(img_crop))

cv2.imshow('img',img)

cv2.waitKey()
