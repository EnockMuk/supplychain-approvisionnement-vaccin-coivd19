// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import './modifier.sol';
contract COVID19 is Securite {
    
            uint index;
            enum Approvisionement{pasPret,pret,enRoute,livrer,receptionner}
            address public fournisseur;
           
            
            struct VACCIN {
                
                uint id;
                string typeVaccin;
                Approvisionement etat;
                address centreHospitalier;
                uint temps;
            
            }
            mapping(uint=>VACCIN)public vaccins;
            
            event Production (address indexed fournisseur,VACCIN vaccin);
            event Transport(address indexed transporteur,VACCIN vaccin );
             event Recu(address indexed beneficiaire,VACCIN vaccin );
            constructor(address _fournisseur){
                fournisseur=_fournisseur;
                produit();
            }
            
            function produit()private {
                
                VACCIN memory vaccin=VACCIN(index,"0 produit",Approvisionement.pasPret,msg.sender,block.timestamp);
                
                vaccins[index]=vaccin;
                
                emit Production(msg.sender,vaccins[index]);
                
            }
            
            function creerProduit(string memory _typeVaccin,address _centreHospitalier)public {
                require(msg.sender==fournisseur,"tu n'es fournisseur");
                index+=1;
                vaccins[index]=VACCIN(index,_typeVaccin,Approvisionement.pret,_centreHospitalier,block.timestamp);
                emit Production(msg.sender,vaccins[index]);
            }
            
            
            function transporterVaccin(uint _index)public seulTransporteur {
              
                require(vaccins[_index].etat==Approvisionement.pret,"ce n'est pas pret");
                vaccins[_index].etat=Approvisionement.enRoute;
                emit Transport (transporteur,vaccins[index]);
            }
            
            function delivrerVaccin(uint _index)public seulTransporteur{
              
                require(vaccins[_index].etat==Approvisionement.enRoute,"ce n'est pas pret");
                vaccins[_index].etat=Approvisionement.livrer;
                emit Transport (transporteur,vaccins[index]);
            }
            
            function reception(uint _index)public {
                
                 require(vaccins[_index].centreHospitalier==msg.sender,"tu n'as pas le droit");
                  require(vaccins[_index].etat==Approvisionement.livrer,"ce n'est pas pret");
                 vaccins[_index].etat=Approvisionement.receptionner;
                  emit Recu(msg.sender,vaccins[index]);
            }
        
            
    
    
    
    
    
    
}
