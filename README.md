LittleSick
==========

What is it?
-----------

A mobile app that hows you the nearest hospital, minor injuries unit, GPs, pharmacies, and many other healthcare related centres.
It is currently aimed at paramedics, but could be easily extended to cater for other users.
LittleSick was developed over a weekend by a inter-disciplinary team including software engineers, NHS managers, paramedics and GPs as part of NHSHackScotland (23-24 March 2013) http://www.nhshackscotland.org.uk.

Why?
----

When someone calls an ambulance they quite rightly expect a patient will receive the best care as fast as possible.
Although A&E tends to be the default port of call for ambulances this is often not the best place.
Many injuries and medical conditions can be treated much faster in places such as a minor injuries unit, or a doctor's surgery, and these offer a much more pleasant environment for a patient.

However, paramedics often travel long distance away from their base into unfamiliar areas, and therefore do not possess the local knowledge that would allow them to take a patient to these alternative treatment centres.
LittleSick is an easy to use cross-platform mobile app that quickly shows paramedics the nearest treatment locations including hospitals, minor injuries units, GPs and pharmacies, and provides contact details.

Technical overview
------------------

An app capable of showing the nearest healthcare provider is clearly of benefit to more than just paramedics, so LittleSick has been written in two independent parts:

* An openly accessible web service that developers can query to obtain the nearest healthcare providers and related information including contact details and (if available) opening hours, with options to filter by distance and type of care provided.

* A front-end web-app that provides an intuitive interface for paramedics to find the nearest and most suitable healthcare provider.
The app has been optimised for use in the high-pressure unpredictable environment that paramedics work in.
It works on all major platforms including iOS and Android smartphones, so does not require any significant investment or training of end-users.

Limitations
-----------

LittleSick is only as good as the available data.
It is currently populated with an example dataset supplied by the NHS.

Try it out
----------

You can access the app on most smartphones/tablets including any iOS device by going to http://littlesick.herokuapp.com/.

If you are using Safari you can open this link, click on the Share button (in the middle of the bottom toolbar) and select Add to Home Screen.
It will add what looks like an app to your device that has the look and feel of an iPhone app.

The first time you use the app it will prompt you to let the app use your current location. Please agree to this or the app won't work. :)

If you are interested in accessing the back-end database see https://github.com/nhshackscotland/nhsscotgeo.

Contact
-------

If you have any issues or questions, please email little-sick-app@googlegroups.com.
