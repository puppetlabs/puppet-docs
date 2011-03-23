//Add rotation javascript using jQuery
//
//Uses a basic associative array to relate paths
//to a set of add images.  A default path is defined
//for unrecognized/new paths in the system.
//


//Using the ready callback from jQuery to "plant" the 
//banner add.  Place this on another even hook if you 
//like, there are no parameters in use here.
$(document).ready(function() { 
	//First parameter is the ID of the add element
	var addEleId = 'content_add';
	//Grab the add element
	var addElement = $("#" + addEleId);
		
	//Grab the current directory (path)
	var pathName = window.location.pathname;
	var pathEles = pathName.split('/');
	var path = '';

	//Get current ads
	if(pathName != '/') { 
	    for(var i in pathEles)
		{
		    if(i < pathEles.length) {
		        if(i != 0) {
			    path += '/' +  pathEles[i];
			}
			else {
			    path += pathEles[i];
			}
		    }
		}
	}
	else { 
	    path = '/';
	}
	//Retreive the appropriate image array
	ads = getAds();
	var curImage = '';
	var theseAds = ads[path];
	if(theseAds != undefined && theseAds.length > 0) { 
	    var curIndex = Math.floor(Math.random() * theseAds.length);
	    var curImage = theseAds[curIndex];
	}

	if(curImage != undefined && curImage.length > 0) { 
	    $("#bannerImage").append('<a href="http://info.puppetlabs.com/puppet-enterprise?utm_source=docs" /><img src="' + curImage + '" border="0" /></a>');
	}
	
});

//Image associative array method, simple array instantiation
//relating paths to banner add images
function getAds()
{
    var ads = new Array();
    //These paths must include HTML paths to display an add
    //any pages that are EXCEPT the root path, which is a
    //single slash 
    //
    //The image paths can be local or remote, link to any image you like...
    //Seperate each image path with a comma
    //syntax is ads['path'] = ['image1_url', 'image2_url']
    //(Note default script paths are local, local paths start with / )
    //
    //First line is path
    //single slash value is the root path
    ads['/'] = ['/files/images/doc_easy.jpg'];
     ads['/index.html'] = [''];   
    ads['/guides/best_practices.html'] = [''];
   ads['/guides/complete_resource_example.html'] = [''];
   ads['/guides/configuring.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/custom_facts.html'] = [''];
   ads['/guides/custom_functions.html'] = [''];
   ads['/guides/custom_types.html'] = [''];
   ads['/guides/development_lifecycle.html'] = [''];
   ads['/guides/environment.html'] = [''];
   ads['/guides/exported_resources.html'] = [''];
   ads['/guides/external_nodes.html'] = [''];
   ads['/guides/faq.html'] = [''];
   ads['/guides/file_serving.html'] = [''];
   ads['/guides/from_source.html'] = [''];
   ads['/guides/installation.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/installing_dashboard.html'] = [''];
   ads['/guides/language_tutorial.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/modules.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/language_guide.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/introduction.html'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/passenger.html'] = [''];
   ads['/guides/platforms.html'] = [''];
   ads['/guides/plugins_in_modules.html'] = [''];
   ads['/guides/provider_development.html'] = [''];
   ads['/guides/reporting.html'] = [''];
   ads['/guides/rest_api.html'] = [''];
   ads['/guides/scaling.html'] = [''];
   ads['/guides/security.html'] = [''];
   ads['/guides/style.html'] = [''];
   ads['/guides/techniques.html'] = [''];
   ads['/guides/templating.html'] = [''];
   ads['/guides/tools.html'] = [''];
   ads['/guides/troubleshooting.html'] = [''];
   ads['/guides/types/'] = ['/files/images/ad_10mins.jpg'];
   ads['/guides/using_dashboard.html'] = [''];
   ads['/guides/virtual_resources.html'] = [''];

   ads['/references/0.24.5/configuration.html'] = [''];
   ads['/references/0.24.5/function.html'] = [''];
   ads['/references/0.24.5/'] = [''];
   ads['/references/0.24.5/indirection.html'] = [''];
   ads['/references/0.24.5/network.html'] = [''];
   ads['/references/0.24.5/report.html'] = [''];
   ads['/references/0.24.5/type.html'] = [''];

   ads['/references/0.24.6/configuration.html'] = [''];
   ads['/references/0.24.6/function.html'] = [''];
   ads['/references/0.24.6/'] = [''];
   ads['/references/0.24.6/indirection.html'] = [''];
   ads['/references/0.24.6/network.html'] = [''];
   ads['/references/0.24.6/report.html'] = [''];
   ads['/references/0.24.6/type.html'] = [''];

   ads['/references/0.24.7/configuration.html'] = [''];
   ads['/references/0.24.7/function.html'] = [''];
   ads['/references/0.24.7/'] = [''];
   ads['/references/0.24.7/indirection.html'] = [''];
   ads['/references/0.24.7/network.html'] = [''];
   ads['/references/0.24.7/report.html'] = [''];
   ads['/references/0.24.7/type.html'] = [''];

   ads['/references/0.24.8/configuration.html'] = [''];
   ads['/references/0.24.8/function.html'] = [''];
   ads['/references/0.24.8/'] = [''];
   ads['/references/0.24.8/indirection.html'] = [''];
   ads['/references/0.24.8/network.html'] = [''];
   ads['/references/0.24.8/report.html'] = [''];
   ads['/references/0.24.8/type.html'] = [''];

   ads['/references/0.24.9/configuration.html'] = [''];
   ads['/references/0.24.9/function.html'] = [''];
   ads['/references/0.24.9/'] = [''];
   ads['/references/0.24.9/indirection.html'] = [''];
   ads['/references/0.24.9/network.html'] = [''];
   ads['/references/0.24.9/report.html'] = [''];
   ads['/references/0.24.9/type.html'] = [''];

   ads['/references/0.25.0/configuration.html'] = [''];
   ads['/references/0.25.0/function.html'] = [''];
   ads['/references/0.25.0/'] = [''];
   ads['/references/0.25.0/indirection.html'] = [''];
   ads['/references/0.25.0/network.html'] = [''];
   ads['/references/0.25.0/report.html'] = [''];
   ads['/references/0.25.0/type.html'] = [''];

   ads['/references/0.25.1/configuration.html'] = [''];
   ads['/references/0.25.1/function.html'] = [''];
   ads['/references/0.25.1/'] = [''];
   ads['/references/0.25.1/indirection.html'] = [''];
   ads['/references/0.25.1/network.html'] = [''];
   ads['/references/0.25.1/report.html'] = [''];
   ads['/references/0.25.1/type.html'] = [''];

   ads['/references/0.25.2/configuration.html'] = [''];
   ads['/references/0.25.2/function.html'] = [''];
   ads['/references/0.25.2/'] = [''];
   ads['/references/0.25.2/indirection.html'] = [''];
   ads['/references/0.25.2/network.html'] = [''];
   ads['/references/0.25.2/report.html'] = [''];
   ads['/references/0.25.2/type.html'] = [''];

   ads['/references/0.25.3/configuration.html'] = [''];
   ads['/references/0.25.3/function.html'] = [''];
   ads['/references/0.25.3/'] = [''];
   ads['/references/0.25.3/indirection.html'] = [''];
   ads['/references/0.25.3/network.html'] = [''];
   ads['/references/0.25.3/report.html'] = [''];
   ads['/references/0.25.3/type.html'] = [''];

   ads['/references/0.25.4/configuration.html'] = [''];
   ads['/references/0.25.4/function.html'] = [''];
   ads['/references/0.25.4/'] = [''];
   ads['/references/0.25.4/indirection.html'] = [''];
   ads['/references/0.25.4/network.html'] = [''];
   ads['/references/0.25.4/report.html'] = [''];
   ads['/references/0.25.4/type.html'] = [''];

   ads['/references/0.25.5/configuration.html'] = [''];
   ads['/references/0.25.5/function.html'] = [''];
   ads['/references/0.25.5/'] = [''];
   ads['/references/0.25.5/indirection.html'] = [''];
   ads['/references/0.25.5/network.html'] = [''];
   ads['/references/0.25.5/report.html'] = [''];
   ads['/references/0.25.5/type.html'] = [''];

   ads['/references/2.6.0/configuration.html'] = [''];
   ads['/references/2.6.0/function.html'] = [''];
   ads['/references/2.6.0/'] = [''];
   ads['/references/2.6.0/indirection.html'] = [''];
   ads['/references/2.6.0/network.html'] = [''];
   ads['/references/2.6.0/report.html'] = [''];
   ads['/references/2.6.0/type.html'] = [''];

   ads['/references/2.6.1/configuration.html'] = [''];
   ads['/references/2.6.1/function.html'] = [''];
   ads['/references/2.6.1/'] = [''];
   ads['/references/2.6.1/indirection.html'] = [''];
   ads['/references/2.6.1/network.html'] = [''];
   ads['/references/2.6.1/report.html'] = [''];
   ads['/references/2.6.1/type.html'] = [''];

   ads['/references/2.6.2/configuration.html'] = [''];
   ads['/references/2.6.2/function.html'] = [''];
   ads['/references/2.6.2/'] = [''];
   ads['/references/2.6.2/indirection.html'] = [''];
   ads['/references/2.6.2/network.html'] = [''];
   ads['/references/2.6.2/report.html'] = [''];
   ads['/references/2.6.2/type.html'] = [''];

   ads['/references/2.6.3/configuration.html'] = [''];
   ads['/references/2.6.3/function.html'] = [''];
   ads['/references/2.6.3/'] = [''];
   ads['/references/2.6.3/indirection.html'] = [''];
   ads['/references/2.6.3/network.html'] = [''];
   ads['/references/2.6.3/report.html'] = [''];
   ads['/references/2.6.3/type.html'] = [''];

   ads['/references/2.6.4/configuration.html'] = [''];
   ads['/references/2.6.4/function.html'] = [''];
   ads['/references/2.6.4/'] = [''];
   ads['/references/2.6.4/indirection.html'] = [''];
   ads['/references/2.6.4/network.html'] = [''];
   ads['/references/2.6.4/report.html'] = [''];
   ads['/references/2.6.4/type.html'] = [''];
    //Return ads
    return ads;
}
