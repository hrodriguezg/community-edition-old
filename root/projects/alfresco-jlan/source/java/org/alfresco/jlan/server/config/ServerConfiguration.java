package org.alfresco.jlan.server.config;

/*
 * ServerConfiguration.java
 *
 * Copyright (c) 2004 Starlasoft. All rights reserved.
 */
 
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

import org.alfresco.jlan.server.NetworkServer;
import org.alfresco.jlan.server.NetworkServerList;
import org.alfresco.jlan.util.Platform;


/**
 * Server Configuration Class
 * 
 * <p>Provides the configuration parameters for the network file servers (SMB/CIFS, FTP and NFS).
 */
public class ServerConfiguration {

	//	Constants
	//
  //  Server name
  
  private String m_serverName;
  
	//	Active server list
	
	private NetworkServerList m_serverList;
			
  //  Configuration sections
  
  private HashMap<String, ConfigSection> m_configSections;
  
	//	Configuration change listeners
	
	private Vector<ConfigurationListener> m_listeners;
		
	//	Flag to indicate that the server configuration has been changed
	
	private boolean m_updated;
			
  /**
   * Construct a server configuration object
   * 
   * @param name String
   */
  public ServerConfiguration( String name) {

    //  Allocate the config sections table
    
    m_configSections = new HashMap<String, ConfigSection>();
    
    //	Allocate the active server list
    
    m_serverList = new NetworkServerList();
    
    // Set the server name
    
    m_serverName = name;
  }

  /**
   * Add a configuration section
   * 
   * @param config ConfigSection
   */
  public final void addConfigSection(ConfigSection config) {
    
    // Add the config section
    
    m_configSections.put( config.getSectionName(), config);
    
    // Notify listeners of the new configuration section
    
    try {
      fireConfigurationChange( ConfigId.ConfigSection, config);
    }
    catch ( InvalidConfigurationException ex) {
    }
  }

  /**
   * Check if the specified configuration section name is available
   * 
   * @param name String
   * @return boolean
   */
  public final boolean hasConfigSection(String name) {
    return m_configSections.containsKey( name);
  }
  
  /**
   * Return the required configuration section
   * 
   * @param name String
   * @return ConfigSection
   */
  public final ConfigSection getConfigSection(String name) {
    return m_configSections.get( name);
  }
  
  /**
   * Remove a configuration section
   * 
   * @param name String
   * @return ConfigSection
   */
  public final ConfigSection removeConfigSection(String name) {
    return m_configSections.remove( name);
  }
  
  /**
   * Remove all configuration sections
   */
  public final void removeAllConfigSections() {
    m_configSections.clear();
  }
  
  /**
   * Return the server name
   * 
   * @return String
   */
  public final String getServerName() {
    return m_serverName;
  }
  
	/**
	 * Add a server to the list of active servers
	 * 
	 * @param srv NetworkServer
	 */
	public final void addServer(NetworkServer srv) {
		m_serverList.addServer(srv);
	}

	/**
	 * Find an active server using the protocol name
	 * 
	 * @param proto String
	 * @return NetworkServer
	 */
	public final NetworkServer findServer(String proto) {
		return m_serverList.findServer(proto);
	}
	
	/**
	 * Remove an active server
	 * 
	 * @param proto String
	 * @return NetworkServer
	 */
	public final NetworkServer removeServer(String proto) {
		return m_serverList.removeServer(proto);
	}
	
	/**
	 * Return the number of active servers
	 *
	 * @return int 
	 */
	public final int numberOfServers() {
		return m_serverList.numberOfServers();
	}

  /**
   * Check if the specified protocol server exists and is running
   * 
   * @param proto String
   * @return boolean
   */
  public final boolean isServerRunning( String proto) {
    
    //  Check if the server exists
    
    NetworkServer srv = findServer( proto);
    if ( srv != null)
      return srv.isActive();
    
    return false;
  }
  
  /**
   * Return the platform type
   * 
   * @return Platorm.Type
   */
  public final Platform.Type getPlatformType() {
      return Platform.isPlatformType();
  }
  
  /**
   * Return the platform type as a string
   * 
   * @return String
   */
  public final String getPlatformTypeString() {
    return Platform.isPlatformType().toString();
  }

	/**
	 * Return the server at the specified index
	 * 
	 * @param idx int
	 * @return NetworkServer
	 */
	public final NetworkServer getServer(int idx) {
		return m_serverList.getServer(idx);
	}
	
	/**
	 * Determine if the server configuration has been updated since loaded
	 * 
	 * @return boolean
	 */
	public final boolean isUpdated() {
		return m_updated;
	}
	
	/**
	 * Set or clear the updated configuration flag
	 * 
	 * @param upd boolean
	 */
	protected final void setUpdated(boolean upd) {
		m_updated = upd;
	}
	
  /**
   * Set the server name
   * 
   * @param name String
   */
  public final void setServerName( String name) {
    m_serverName = name;
  }
  
	/**
	 * Add a configuration change listener
	 * 
	 * @param listener ConfigurationListener
	 */
	public final void addListener(ConfigurationListener listener) {
		
		//	Check if the listener list is allocated
		
		if ( m_listeners == null)
			m_listeners = new Vector<ConfigurationListener>();
			
		//	Add the configuration change listener
		
		m_listeners.addElement(listener);
	}
	
	/**
	 * Remove a configuration change listener
	 * 
	 * @param listener ConfigurationListener
	 */
	public final void removeListener(ConfigurationListener listener) {
		
		//	Check if the listener list is valid
		
		if ( m_listeners == null)
			return;
			
		//	Remove the listener
		
		m_listeners.removeElement(listener);
	}
	
	/**
	 * Check if there are any configuration change listeners
	 * 
	 * @return boolean
	 */
	public final boolean hasConfigurationListeners() {
		if ( m_listeners == null)
			return false;
		return m_listeners.size() > 0 ? true : false;
	}
	
	/**
	 * Notify all registered configuration change listeners of a configuration change
	 * 
	 * @param id int
	 * @param newVal Object
	 * @return int
	 * @throws InvalidConfigurationException
	 */
	protected final int fireConfigurationChange(int id, Object newVal)
		throws InvalidConfigurationException {

		//	Set the configuration updated flag
		
		setUpdated(true);
		
		//	Check if there are any listeners registered
		
		if ( hasConfigurationListeners() == false)
			return ConfigurationListener.StsIgnored;
			
		//	Inform each registered listener of the change
		
		int sts = ConfigurationListener.StsIgnored;
		
		for ( int i = 0; i < m_listeners.size(); i++) {
			
			//	Get the current configuration change listener
			
			ConfigurationListener cl = m_listeners.elementAt(i);
			
			//	Inform the listener of the configuration change
			
			int clSts = cl.configurationChanged(id, this, newVal);
			
			//	Keep the highest status
			
			if ( clSts > sts)
				sts = clSts;
		}
		
		//	Return the change status
		
		return sts;
	}
	
	/**
	 * Load the configuration from the specified location. The location depends on the
	 * implementation of the configuration.
	 * 
	 * @param location String
	 * @exception IOException
	 * @exception InvalidConfigurationException
	 */
	public void loadConfiguration(String location)
		throws IOException, InvalidConfigurationException {
			
		//	Not implemented in the base class
		
		throw new IOException("Not implemented");
	}
	
	/**
	 * Save the configuration to the specified location. The location depends on the
	 * implementation of the configuration.
	 * 
	 * @param location String
	 * @exception IOException
	 */
	public void saveConfiguration(String location)
		throws IOException {
			
		//	Not implemented in the base class
	
		throw new IOException("Not implemented");
	}
	
	/**
	 * Close the configuration
	 */
	public void closeConfiguration() {
	  
	  // Close the configuration sections
	  
	  if ( m_configSections != null) {

	    Set<String> keys = m_configSections.keySet();
	    Iterator<String> keysIter = keys.iterator();
	    
	    while ( keysIter.hasNext()) {
	      String configName = keysIter.next();
	      ConfigSection configSection = m_configSections.get(configName);
		  
	      try {
	        
	        // Close the configuration section and remove
	        
	        configSection.closeConfig();
	      }
	      catch ( Exception ex) {
	      }
	    }
	    
	    // Clear the config sections list
	    
	    m_configSections.clear();
	  }
	}
}