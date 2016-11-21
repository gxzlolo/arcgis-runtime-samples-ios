//
// Copyright 2016 Esri.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import UIKit
import ArcGIS

class StretchRendererViewController: UIViewController, StretchRendererSettingsVCDelegate {
    
    @IBOutlet var mapView: AGSMapView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var visualEffectView: UIVisualEffectView!
    
    private var raster: AGSRaster!
    private var rasterLayer: AGSRasterLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //add the source code button item to the right of navigation bar
        (self.navigationItem.rightBarButtonItem as! SourceCodeBarButtonItem).filenames = ["StretchRendererViewController", "StretchRendererSettingsVC", "StretchRendererTypeCell", "StretchRendererInputCell"]
        
        //create raster
        self.raster = AGSRaster(name: "ShastaBW", extension: "tif")
        
        //create raster layer using the raster
        self.rasterLayer = AGSRasterLayer(raster: self.raster)
        
        //initialize a map with raster layer as the basemap
        let map = AGSMap(basemap: AGSBasemap(baseLayer: self.rasterLayer))
        
        //assign map to the map view
        self.mapView.map = map
        
        //styling
        self.containerView.layer.cornerRadius = 5
    }
    
    //MARK: - StretchRendererSettingsVCDelegate
    
    func stretchRendererSettingsVC(stretchRendererSettingsVC: StretchRendererSettingsVC, didSelectStretchParameters parameters: AGSStretchParameters) {
        
        self.toggleSettingsView(false)
        
        let renderer = AGSStretchRenderer(stretchParameters: parameters, gammas: [], estimateStatistics: true, colorRamp: AGSColorRamp(type: .None, size: 1))
        self.rasterLayer.renderer = renderer
    }
    
    //MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "StretchRendererSettingsVCSegue" {
            let controller = segue.destinationViewController as! StretchRendererSettingsVC
            controller.delegate = self
            controller.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    //MARK: - Actions
    
    @IBAction func editRendererAction() {
        self.toggleSettingsView(true)
    }
    
    //MARK: - Show/hide settings view
    
    private func toggleSettingsView(on: Bool) {
        self.visualEffectView.hidden = !on
    }
}
