/*
 * Cocktail, HTML rendering engine
 * http://haxe.org/com/libs/cocktail
 *
 * Copyright (c) Silex Labs
 * Cocktail is available under the MIT license
 * http://www.silexlabs.org/labs/cocktail-licensing/
*/
package org.intermedia.model;
import org.intermedia.Settings;

/**
 * Load and hold the RSS data. Notifies the view when a change occurs
 * 
 * @author Raphael Harmel
 */

//import cocktail.Cocktail;

class ApplicationModel
{

	// Called when cells data has been successfully loaded
	public var onModelCellDataLoaded:ListData->Void;
	
	// Called when the detail of a cell has been successfully loaded
	public var onModelDetailDataLoaded:DetailData->Void;
	
	// Called when there was a loading error
	public var onModelDataLoadError:Feed->Dynamic->Void;
	
	// Called when the loading starts
	public var onModelStartsLoading:Void->Void;
	
	// A ref to the class managing external data loading and parsing
	private var _dataLoader : DataLoader;
	
	// Store a reference to each loaded CellData
	private var _loadedCellsData : Array<CellData>;
	
	// Store a reference to each loaded DetailData
	private var _loadedDetailData : Array<DetailData>;
	
	static inline var CELL_QTY:Int = 15;

	public function new() 
	{
		// initialise private attributes
		_loadedCellsData = new Array<CellData>();
		_loadedDetailData = new Array<DetailData>();
		
		// init dataLoader
		initDataLoader();
	}
	
	/**
	 * init data loader
	 */
	public function initDataLoader():Void
	{
		// init _dataLoader with online switch
		_dataLoader = new DataLoader(Settings.getInstance().online);		
	}
	
	/**
	 * Calls onModelStartsLoading, then calls load() on the DataLoader with the right number of cell to load
	 * @param	numberOfCellsToLoad
	 */
	public function loadCellData(id:String):Void
	{
		var feed:Feed = {id:0,ressource:"",thumb:"",title:"",url:"",generatedBy:""};
		
		// get the feed corresponding to the id (=the url)
		if (id == Feeds.FEED_1.url)
		{
			feed = Feeds.FEED_1;
		}
		else if (id == Feeds.FEED_2.url)
		{
			feed = Feeds.FEED_2;
		}
		else if (id == Feeds.FEED_3.url)
		{
			feed = Feeds.FEED_3;
		}
		
		// if first data loading is occuring
		if (_loadedCellsData.length == 0)
		{
			// calls onModelStartsLoading if initialised
			if(onModelStartsLoading != null)
			{
				onModelStartsLoading();
			}
		}
		
		// Calls load() on the DataLoader with the right number of cell to load
		_dataLoader.loadCellData(feed, CELL_QTY,onCellsDataLoadComplete, onModelDataLoadError);
	}
	
	/**
	 * Calls onModelStartsLoading, then calls load() on the DataLoader with the right CellData to retrieve the DetailData
	 * @param	cellData
	 */
	/*public function loadDetailData(cellData:CellData):Void
	{
		// calls onModelStartsLoading if initialised
		if(onModelStartsLoading != null)
		{
			onModelStartsLoading();
		}
		
		// Calls load() on the DataLoader with the right CellData to retrieve the DetailData
		_dataLoader.loadDetailData(cellData, onDetailDataLoadComplete, onModelDataLoadError);
	}*/

	/**
	 * Call onModelCellDataLoaded with the cellData array
	 * @param	cellsData
	 */
	private function onCellsDataLoadComplete(listData:ListData):Void
	{
		// reset _loadedCellsData
		_loadedCellsData = new Array<CellData>();
		
		// add cellsData to _loadedCellsData
		for ( cellData in listData.cells)
		{
			_loadedCellsData.push(cellData);
		}
		
		// call onModelCellDataLoaded (if initialised) with _loadedCellsData as parameters
		if (onModelCellDataLoaded != null)
		{
			onModelCellDataLoaded(listData);
		}
	}
	
	/**
	 * Call onModelDetailDataLoaded with the DetailData
	 * @param	detailData
	 */
	private function onDetailDataLoadComplete(detailData:DetailData):Void
	{
		// set _loadedDetailData to detailData
		_loadedDetailData.push(detailData);
		
		// call onModelDetailDataLoaded (if initialised) with detailData as parameters
		if (onModelDetailDataLoaded != null)
		{
			onModelDetailDataLoaded(detailData);
		}
	}
	
}

/**
 * Holds Title, author, thumbUrl...
 * Could also use a Hash with the id a key for faster search
 */
typedef	CellData =
{
	var id:Int;
	var title:String;
	var author:String;
	var thumbUrl:String;
	var category:String;
	var description:String;
	var content:String;
}

/**
 * Holds Title, content...
 * Could also use a Hash with the id a key for faster search
 */
typedef DetailData =
{
	var id:Int;
	var title:String;
	var author:String;
	var thumbUrl:String;
	var category:String;
	var description:String;
}

/**
 * ListData model defines a a hash of CellData Array, each hash containing the list id
 */
typedef ListData =
{
	var id:String;
	var cells:Array<CellData>;
}

/**
 * Size defines the size of a dom
 */
typedef Size =
{
	var width:Int;
	var height:Int;
}
